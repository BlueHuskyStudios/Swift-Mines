//
//  NewGameConfiguration.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
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
    
    
    static let easy         = NewGameConfiguration(difficulty: .easy)
    static let intermediate = NewGameConfiguration(difficulty: .intermediate)
    static let advanced     = NewGameConfiguration(difficulty: .advanced)
    static let `default`    = NewGameConfiguration(difficulty: .default)
}



public extension NewGameConfiguration {
    /// Counts the number of mines that should appear on the board with this configuration
    var countNumberOfMines: UInt {
        return numberOfMines.count(in: boardSize)
    }
}
