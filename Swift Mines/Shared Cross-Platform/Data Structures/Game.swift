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
        
        evaluateWinState()
    }
    
    
    
    /// Immediately considers the game lost, revealing all squares and marking the one the user clicked as the culprit
    ///
    /// - Parameter detonatedMineLocation: The location of the mine that the player clicked
    private mutating func loseGame(detonatedMineLocation: UIntPoint) {
        print("Board has a mine at \(detonatedMineLocation)! Game over")
        board.revealAll(reason: .chainReaction)
        board.content[detonatedMineLocation].base.reveal(reason: .manual)
        playState.lose()
    }
    
    
    /// Evaluates whether the user has won the game. If the user has won, the state is mutated to reflect that win
    private mutating func evaluateWinState() {
        switch playState {
        case .notStarted,
             .win(startDate: _, winDate: _),
             .loss(startDate: _, lossDate: _):
            // Cannot go to Win from this state
            return
            
        case .playing(let startDate):
            if userHasWonGame() {
                self.playState = .win(startDate: startDate, winDate: Date())
            }
        }
    }
    
    
    /// Checks to determine whether the user has won the game
    private func userHasWonGame() -> Bool {
        guard self.numberOfFlagsRemainingToPlace == 0 else {
            // If the user has not placed all the flags, they have not yet won
            return false
        }
        
        return self                                         // Look at the game
            .board                                          // Look at the game's board
            .content                                        // Look at the board's content
            .lazy                                           // Evaluate the following in just one loop
            .flatMap { $0 }                                 // Flatten the 2D array of board squares into a 1D array
            .filter { $0.hasMine && $0.flagStyle == .sure } // Look at the squares which have mines and a for-sure flag
            .count                                          // Count how many squares meet the above criteria
            == self.totalNumberOfMines                      // If that number is equal to the total number of mines,
                                                            //     the player has won the game!
    }
    
    
    /// Immediately places a flag of the given style at the given location.
    ///
    /// If you pass `.specific`, then the style of flag you specify will be placed there, even if it's already placed
    /// or out-of-cycle.
    ///
    /// If you pass `.automatic`, then the next flag in the cycle will be placed there. See the documentation for
    /// `BoardSquare.cycleFlag()` for that behavior.
    ///
    /// - Parameters:
    ///   - style:    The style of the flag to place
    ///   - location: <#location description#>
    mutating func placeFlag(style: NextFlagStyle, at location: UIntPoint) {
        switch style {
        case .specific(let style):
            board.content[location].placeFlag(style: style)
        
        case .automatic:
            board.content[location].cycleFlag()
        }
    }
}


// MARK: New Game

public extension Game {
    /// Generates a new board with the same dimensions, style, and number of mines as the current one
    /// - Parameter location: The location where there should not be near a mine
    fileprivate mutating func regenerateBoard(disallowingMinesNear location: Board.Location) {
        self.board = Board.generateNewBoard(
                size: board.size,
                totalNumberOfMines: self.totalNumberOfMines,
                disallowingMinesNear: location
            )
            .annotated(baseStyle: board.style)
    }
    
    
    /// Discards the current game and generates a new one
    mutating func startNewGame() {
        self = .new(size: board.size, totalNumberOfMines: totalNumberOfMines)
    }
}


// MARK: Introspection

public extension Game {
    
    /// Counts the number of flags which the user hasn't yet placed
    var numberOfFlagsRemainingToPlace: UInt { totalNumberOfMines - numberOfSquaresThoughtToBeMines }
    
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
