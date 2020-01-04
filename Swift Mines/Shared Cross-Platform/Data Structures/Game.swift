//
//  Game.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import RectangleTools



/// Everything we need to know in order to display a game of Mines while it's being played
public struct Game {
    public let id: UUID
    public fileprivate(set) var board: Board.Annotated
    public fileprivate(set) var playState: PlayState
    public let totalNumberOfMines: UInt
    
    
    fileprivate init(id: UUID = UUID(), board: Board.Annotated, playState: PlayState, totalNumberOfMines: UInt) {
        self.id = id
        self.board = board
        self.playState = playState
        self.totalNumberOfMines = totalNumberOfMines
    }
    
    
    public init(id: UUID = UUID(), board: Board.Annotated, playState: PlayState) {
        self.init(
            id: id,
            board: board,
            playState: playState,
            totalNumberOfMines: board.totalNumberOfMines
        )
    }
}



extension Game: Identifiable {}
extension Game: Hashable {}


// MARK: Convenience init

public extension Game {
    static func new(size: UIntSize, totalNumberOfMines: UInt) -> Self {
        self.init(
            board: Board.generateNewBoard(size: size,
                                          totalNumberOfMines: totalNumberOfMines)
                .annotated(baseStyle: .default),
            playState: .notStarted,
            totalNumberOfMines: totalNumberOfMines
        )
    }
}


// MARK: Functionality

public extension Game {
    
    /// Mutates the game board to reflect the result of the user taking the given action at the given location
    ///
    /// - Parameters:
    ///   - action:   The action the user took
    ///   - location: The location of the action
    mutating func updateBoard(after action: UserAction, at location: Board.Location) {
        switch playState {
        case .playing:
            switch action {
            case .dig: dig(at: location)
            case .placeFlag(let style): placeFlag(style: style, at: location)
            }
            
        case .notStarted:
            self.playState = .playing(startDate: Date())
            
            switch action {
            case .dig:
                
                if board.content[location].mineContext != .clear(distance: .farFromMine) {
                    regenerateBoard(disallowingMinesNear: location)
                }
                
                dig(at: location)
                
            case .placeFlag(let style):
                placeFlag(style: style, at: location)
            }
            
        case .win, .loss:
            // Nothing to do?
            break
        }
    }
    
    
    /// "Dig" up the square at the given location. If it's a mine, the game is lost. If it's clear, then more info
    /// about the mines is revealed.
    ///
    /// - Parameter location: The location where to dig
    private mutating func dig(at location: UIntPoint) {
        print("Digging at", location)
        let revealedSquare = board.revealSquare(at: location, reason: .manual)
        
        switch revealedSquare.mineContext {
        case .clear(distance: .farFromMine):
            print("Revealing neighboring clear squares")
            board.revealClearSquares(touching: location)
            
        case .clear(distance: _):
            print("Only revealing square")
            
        case .mine:
            loseGame(detonatedMineLocation: location)
        }
    }
    
    
    
    private mutating func loseGame(detonatedMineLocation: UIntPoint) {
        print("Board has a mine at \(detonatedMineLocation)! Game over")
        board.revealAll(reason: .chainReaction)
        board.content[detonatedMineLocation].base.reveal(reason: .manual)
        playState.lose()
    }
    
    
    private mutating func placeFlag(style: NextFlagStyle, at location: UIntPoint) {
        switch style {
        case .specific(let style):
            board.content[location].placeFlag(style: style)
        
        case .automatic:
            board.content[location].cycleFlag()
        }
    }
    
    
    /// Generates a new board with the same dimensions, style, and number of mines as the current one
    /// - Parameter location: The location where there should not be near a mine
    private mutating func regenerateBoard(disallowingMinesNear location: Board.Location) {
        self.board = Board.generateNewBoard(
                size: board.size,
                totalNumberOfMines: self.totalNumberOfMines,
                disallowingMinesNear: location
            )
            .annotated(baseStyle: board.style)
    }
}


// MARK: Introspection

public extension Game {
    
    /// Counts the number of mines which the user hasn't yet flagged or revealed
    var numberOfMinesRemainingToFind: UInt { totalNumberOfMines - numberOfSquaresThoughtToBeMines }
    
    /// Counts the number of squares in the game which the user thinks/knowns are mines
    var numberOfSquaresThoughtToBeMines: UInt {
        return UInt(
            self                                  // Start from the entire game
                .board                            // Focus on the board
                .content                          // Focus on the content (rows of squares)
                .lazy                             // Evaluatem lazily
                .flatMap { $0 }                   // Flatten the rows-of-squares into just the squares
                .filter { $0.isThoughtToBeAMine } // Only consider those squares which the user thinks are mines
                .count                            // Count them up!
        )
    }
    
    var numberOfSecondsSinceGameStarted: UInt {
        switch playState {
        case .notStarted:
            return 0
            
        case .playing(let startDate):
            return UInt(-startDate.timeIntervalSinceNow)
            
        case .win(let startDate, let endDate),
             .loss(let startDate, let endDate):
            return UInt(endDate.timeIntervalSince(startDate))
        }
    }
}



// MARK: - PlayState

public extension Game {
    enum PlayState {
        case notStarted
        case playing(startDate: Date)
        case win(startDate: Date, winDate: Date)
        case loss(startDate: Date, lossDate: Date)
    }
}



extension Game.PlayState: Hashable {}



extension Game.PlayState {
    
    var startDate: Date? {
        switch self {
        case .notStarted:
            return nil
            
        case .playing(let startDate),
             .win(let startDate, winDate: _),
             .loss(let startDate, lossDate: _):
            return startDate
        }
    }
    
    mutating func lose() {
        let now = Date()
        self = .loss(startDate: startDate ?? now, lossDate: now)
    }
}



// MARK: - UserAction

public extension Game {
    
    /// An action the user took while playing
    enum UserAction {
        
        /// The user dug at the spot, either revelaing a mine or a place where there was no mine
        case dig
        
        /// The user placed a flag on a spot, either declaring that there is a mine there, or noting it for later
        ///
        /// - Parameter style: The style of flag to place
        case placeFlag(style: NextFlagStyle)
    }
    
    
    
    /// Which flag style to use next
    enum NextFlagStyle {
        
        /// Use a specific flag style next
        case specific(style: BoardSquare.ExternalRepresentation.FlagStyle)
        
        /// Automatically choose a flag style based on the current flag
        case automatic
    }
}
