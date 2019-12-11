//
//  Board + random.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import OptionalTools
import RectangleTools



public extension Board {
    
    /// Finds any point on this board that has no mine
    ///
    /// - Returns: A point on this board which does not have a mine
    /// - Throws: `BoardGenerationError.filledWithMines` if the board is already filled with mines
    func anyPointWithoutAMine() throws -> UIntPoint {
        try size
            .lazy
            .map(UIntPoint.init)
            .filter { !self.square(at: $0).hasMine }
            .randomElement()
            .unwrappedOrThrow(error: BoardGenerationError.filledWithMines)
    }
    
    
    /// Generates an entire board, ready to be played
    ///
    /// - Parameters:
    ///   - size:               How big you want the resulting board
    ///   - totalNumberOfMines: The amount of mines in the resulting board. Obviously, if this is greater than the
    ///                         number of squares, then all the squares will be mines
    static func generateNewBoard(size: UIntSize, totalNumberOfMines: UInt) -> Board {
        let size = size.greaterThanZero
        var board = Board.empty(size: size)
        
        size
            .lazy
            .shuffled()
            .onlyFirst(totalNumberOfMines)
            .map(IntPoint.init(_:))
            .forEach { point in
                board.content[point.x][point.y].giveMine()
            }
        
        return board
    }
    
    
    /// Creates and returns an empty board
    ///
    /// - Parameter size: How big you want the resulting board
    static func empty(size: UIntSize) -> Board {
        self.init(content: size.greaterThanZero.map2D { _ in .empty })
    }
    
    
    
    /// An error that can occur while generating a board
    enum BoardGenerationError: Error {
        /// Attempted to add a new mine to a board which is already full of mines
        case filledWithMines
    }
}
