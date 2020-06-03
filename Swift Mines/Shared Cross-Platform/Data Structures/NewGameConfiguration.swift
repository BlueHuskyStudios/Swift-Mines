//
//  NewGameConfiguration.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation
import RectangleTools



/// A predefined game configuration
public struct NewGameConfiguration {
    
    /// How big the board should be
    public var boardSize: Board.Size
    
    /// How many mines should be on the board
    public var numberOfMines: Game.TotalNumberOfMines
}



public extension NewGameConfiguration {
    
    /// Generates a configuration appropriate for the given difficulty
    ///
    /// - Parameter difficulty: How difficult a new game's configuration should be
    init(difficulty: PredefinedGameDifficulty) {
        switch difficulty {
        case .easy: self.init(boardSize: 10 * 10, numberOfMines: .auto)
        case .intermediate: self.init(boardSize: 20 * 15, numberOfMines: .auto)
        case .advanced: self.init(boardSize: 30 * 20, numberOfMines: .auto)
        }
    }
    
    
    /// Infers the difficulty of this configuration, or returns `nil` if this config doesn't perfectly match a
    /// predefined difficulty
    func inferredDifficulty() -> PredefinedGameDifficulty? {
        switch ((width: boardSize.height, height: boardSize.height), numberOfMines) {
        case ((width: 10, height: 10), .auto): return .easy
        case ((width: 20, height: 15), .auto): return .intermediate
        case ((width: 30, height: 20), .auto): return .advanced
            
        default: return nil
        }
    }
    
    
    /// The predefined configuration for an easy game.
    /// A good entry-level configuration for new players, or those not looking for a challenge.
    static let easy         = NewGameConfiguration(difficulty: .easy)
    
    /// The predefined configuration for a game of intermediate difficulty.
    /// A good configuration for players who've mastered the basics and want to graduate to a more challenging board.
    static let intermediate = NewGameConfiguration(difficulty: .intermediate)
    
    /// The predefined configuration for a game of advanced difficulty.
    /// A good configuration for players who've become bored of easier boards and want a bigger challenge.
    static let advanced     = NewGameConfiguration(difficulty: .advanced)
    
    /// The predefined configuration for a game where no assumptions are made of the player.
    /// A good configuration for the first board shown to players.
    static let `default`    = NewGameConfiguration(difficulty: .default)
}



public extension NewGameConfiguration {
    
    /// Counts the number of mines that should appear on the board with this configuration
    var countNumberOfMines: UInt {
        return numberOfMines.count(in: boardSize)
    }
    
    
    /// Returns the number of mines which should appear on a board with this configuration, pretending that this
    /// configuration always has `.auto` number of mines
    var goodAutomaticNumberOfMines: UInt {
        return Game.TotalNumberOfMines.auto.count(in: boardSize)
    }
}



// MARK: - Conversion

public extension NewGameConfiguration {
    
    /// Creates a new game configuration based on an existing game
    ///
    /// - Parameter game: The game from which to infer a configuration
    init(_ game: Game) {
        self.boardSize = game.board.size
        self.numberOfMines = .init(game.totalNumberOfMines)
    }
}
