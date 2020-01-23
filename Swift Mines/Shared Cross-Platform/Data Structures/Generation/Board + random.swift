//
//  Board + random.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2019 Ben Leggiero BH-1-PS
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
    ///                         number of squares minus the 9 around the given location, then all the squares will be
    ///                         mines
    ///   - safeLocation:       The location where there should be no mines, used for the user's first
    ///                         move. Defaults to a random location on the board.
    static func generateNewBoard(size: Size,
                                 totalNumberOfMines: UInt,
                                 disallowingMinesNear safeLocation: Location
    ) -> Board {
        let size = size.greaterThanZero
        var board = Board.empty(size: size)
        let safeLocation = Size.Index(safeLocation)
        
        size.shuffled()
            .discarding(where: { $0.isTouching(safeLocation, tolerance: 2) })
            .onlyFirst(totalNumberOfMines)
            .map(IntPoint.init)
            .forEach { point in
                board.content[point].giveMine()
            }
        
        return board
    }
    
    
//    /// Generates an entire board, ready to be played
//    ///
//    /// - Parameters:
//    ///   - size:               How big you want the resulting board
//    ///   - totalNumberOfMines: The amount of mines in the resulting board. Obviously, if this is greater than the
//    ///                         number of squares minus the 9 around the given location, then all the squares will be
//    ///                         mines
//    ///   - safeLocation:       _optional_ - The location where there should be no mines, used for the user's first
//    ///                         move. Defaults to a random location on the board.
//    @inlinable
//    static func generateNewBoard(size: Size, totalNumberOfMines: UInt) -> Board {
//        generateNewBoard(size: size,
//                         totalNumberOfMines: totalNumberOfMines,
//                         disallowingMinesNear: Location(size.randomElement()!))
//    }
    
    
    /// Creates and returns an empty board
    ///
    /// - Parameter size: How big you want the resulting board
    static func empty(size: Size) -> Board {
        self.init(content: size.greaterThanZero.map2D { _ in .empty })
    }
    
    
    
    /// An error that can occur while generating a board
    enum BoardGenerationError: Error {
        /// Attempted to add a new mine to a board which is already full of mines
        case filledWithMines
    }
}
