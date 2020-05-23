//
//  Game.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import RectangleTools
import AVKit



/// Everything we need to know in order to display a game of Mines while it's being played
public struct Game {
    
    /// The unique identifier for this game
    public let id: UUID
    
    /// The board that the player sees
    public fileprivate(set) var board: Board.Annotated
    
    /// The current state of play
    public fileprivate(set) var playState: PlayState
    
    /// A cache of the number of mines which are presented in this game.
    ///
    /// If you iterate over the `board` and count the number of squares with mines, it should always equal this number.
    public let totalNumberOfMines: UInt
    
    
    /// Creates a game based on the given pre-checked parameters
    ///
    /// - Attention: This initializer is simple. It does no checking. If the combination of parameters you give are
    ///              inconsistent, then the game will be in an invalid state and undefined behavior might occur. For
    ///              this reason, this initializer is file-private. Do not make it any more public; instead make
    ///              specialized initializers which check the parameters before passing them to this one.
    ///
    /// - Parameters:
    ///   - id:                 _optional_ - The ID of the new game. Defaults to a randomly-generated one
    ///   - board:              The annotated board on which the user will play
    ///   - playState:          The starting state of play
    ///   - totalNumberOfMines: The number of mines in `board`, in case you already calculated that. If you don't
    ///                         specify this, another initializer will be used which calculates it based on `board`
    fileprivate init(id: UUID = UUID(), board: Board.Annotated, playState: PlayState, totalNumberOfMines: UInt) {
        self.id = id
        self.board = board
        self.playState = playState
        self.totalNumberOfMines = totalNumberOfMines
    }
    
    
    /// Creates a game based on the given pre-created parameters
    ///
    /// - Parameters:
    ///   - id:                 _optional_ - The ID of the new game. Defaults to a randomly-generated one
    ///   - board:              The annotated board on which the user will play
    ///   - playState:          The starting state of play
    public init(id: UUID = UUID(), board: Board.Annotated, playState: PlayState) {
        self.init(
            id: id,
            board: board,
            playState: playState,
            totalNumberOfMines: board.totalNumberOfMines()
        )
    }
}



extension Game: Identifiable {}
extension Game: Hashable {}


// MARK: Convenience init

public extension Game {
    /// Starts a new game with a board of the given size, optionally specifying a number of mines
    ///
    /// - Parameters:
    ///   - size:               The size of the board in the new game
    ///   - totalNumberOfMines: _optional_ - The maximum number of mines to place on the board. No matter what option
    ///                         is chosen, there will always be an area without mines where the user first clicks.
    ///                         Defaults to `.auto`
    ///
    /// - Returns: The newly-created game
    static func new(size: Board.Size, totalNumberOfMines: TotalNumberOfMines = .auto) -> Self {
        self.init(
            board: Board.empty(size: size)
                .annotated(baseStyle: .default),
            playState: .notStarted,
            totalNumberOfMines: totalNumberOfMines.count(in: size)
        )
    }
    
    
    /// Starts a new game with a board of the given configuration
    ///
    /// - Parameter configuration: How to configure the new game
    ///
    /// - Returns: The newly-created game
    @inlinable
    static func new(_ configuration: NewGameConfiguration) -> Self {
        new(size: configuration.boardSize,
            totalNumberOfMines: configuration.numberOfMines)
    }
    
    
    /// Starts a good default new game when the user hasn't expressed any preference
    ///
    /// - Returns: The newly-created game
    static func basicNewGame() -> Self {
        new(size: Board.Size(width: 10, height: 10))
    }
    
    
    
    /// Describes the total number of mines to place on a new game board
    enum TotalNumberOfMines: ExpressibleByIntegerLiteral {
        
        /// Don't place any mines on the board
        case none
        
        /// Choose some number of mines to place based on the board's size
        case auto
        
        /// Place a specific number of mines on the board
        case custom(count: UInt)
        
        
        
        public typealias IntegerLiteralType = UInt
        
        
        
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
        
        public init(_ value: UInt) {
            if value == 0 {
                self = .none
            }
            else {
                self = .custom(count: value)
            }
        }
        
        
        /// Returns the number of mines to place on a board of the given size
        ///
        /// - Parameter boardSize: The size of the board onto which some number of mines will be placed
        func count(in boardSize: Board.Size) -> UInt {
            switch self {
            case .none:              return 0
            case .auto:              return UInt((CGFloat(boardSize.area) / 10).rounded())
            case .custom(let count): return count
            }
        }
    }
}


let soundUrl = Bundle.main.url(forResource: "Mine Explosion", withExtension: "mp3")!
let soundData = try! Data(contentsOf: soundUrl, options: Data.ReadingOptions.mappedIfSafe)
let player: AVAudioPlayer = {
    let player = try! AVAudioPlayer(data: soundData, fileTypeHint: AVFileType.mp3.rawValue)
    player.prepareToPlay()
    return player
}()


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
            case .dig:
                if !board.hasFlag(at: location) { // Don't dig where the user already thinks there's a mine
                    dig(at: location)
                }
                
            case .placeFlag(let style):
                placeFlag(style: style, at: location)
            }
            
        case .notStarted:
            self.playState = .playing(startDate: Date())
            
            switch action {
            case .dig:
                regenerateBoard(disallowingMinesNear: location)
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
        
        defer { winIfGameIsOver() }
        
        print("Digging at", location)
        let revealedSquare = board.revealSquare(at: location, reason: .manual)
        
        switch revealedSquare.mineContext {
        case .clear(proximity: .farFromMine):
            print("Revealing neighboring clear squares")
            board.revealClearSquares(touching: location)
            
        case .clear(proximity: _):
            print("Only revealing square")
            
        case .mine:
            loseGame(detonatedMineLocation: location)
        }
    }
    
    
    
    /// Immediately considers the game lost, revealing all squares and marking the one the user clicked as the culprit
    ///
    /// - Parameter detonatedMineLocation: The location of the mine that the player clicked
    private mutating func loseGame(detonatedMineLocation: UIntPoint) {
        print("Board has a mine at \(detonatedMineLocation)! Game over")
        board.revealAll(reason: .chainReaction)
        board.content[detonatedMineLocation].base.reveal(reason: .manual)
        playState.lose()
        
//        do {
//            player.prepareToPlay()
            player.volume = 1
            player.play()
//        } catch {
//            print("Failed to create AVAudioPlayer")
//        }
    }
    
    
    /// Evaluates whether the user has won the game. If the user has won, the state is mutated to reflect that win
    private mutating func winIfGameIsOver() {
        switch playState {
        case .notStarted,
             .win(startDate: _, winDate: _),
             .loss(startDate: _, lossDate: _):
            // Cannot go to Win from this state
            return
            
        case .playing(let startDate):
            if playerHasWonGame() {
                self.playState = .win(startDate: startDate, winDate: Date())
            }
        }
    }
    
    
    /// Checks to determine whether the user has won the game
    private func playerHasWonGame() -> Bool {
        return self                                 // Look at the game
            .board                                  // Look at the game's board
            .content                                // Look at the board's content
            .lazy                                   // Evaluate the following in just one loop
            .flatMap { $0 }                         // Flatten the 2D array of board squares into a 1D array
            .discarding { ($0.hasMine               // Ignore at the squares which have mines
                           || $0.base.isRevealed) } // Ignore the square that the user has revealed
            .isEmpty                                // If there are none left (all squares are either revealed or have a mine), the player has won
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
    ///   - location: The location where the flag should be placed
    private mutating func placeFlag(style: NextFlagStyle, at location: UIntPoint) {
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
    /// 
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
    ///
    /// - Parameter configuration: _optional_ The configuration of the new game. Defaults to the current configuration.
    mutating func startNewGame() {
        self = .new(size: board.size, totalNumberOfMines: .custom(count: totalNumberOfMines))
    }
    
    
    /// Discards the current game and generates a new one
    ///
    /// - Parameter configuration: _optional_ The configuration of the new game. Defaults to the current configuration.
    mutating func startNewGame(configuration: NewGameConfiguration) {
        self = .new(configuration)
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
