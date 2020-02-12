//
//  Board + random.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2020 Ben Leggiero BH-1-PS
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
    /// - Note:
    /// This works well if the given number of mines is low enough to allow the safe area around the given
    /// `safeLocation`. However, if the given number of mines is so large that it would be impossible to have that
    /// number of mines on the board AND the given safe location (e.g. a 10 × 10 board with 99 mines), then this
    /// function will err on the side of the safe location. That is to say, when requesting a 10 × 10 board with 99
    /// mines, if the `safeLocation` is in the center, the returned board would actually have 91 mines; every square
    /// would have a mine except for the one where the user clicked and those 8 around it.
    ///
    /// Similarly, if you request a 10 × 10 board with 10,000 mines, the resulting board will still only have 91 mines
    /// in it.
    ///
    /// - Parameters:
    ///   - size:               How big you want the resulting board
    ///   - totalNumberOfMines: The amount of mines in the resulting board. Obviously, if this is greater than the
    ///                         number of squares minus the given `safeLocation` and the 8 around it, then all the
    ///                         squares will be mines.
    ///   - safeLocation:       The location where there should be no mines, used for the player's first move.
    static func generateNewBoard(size: Size,
                                 totalNumberOfMines: UInt,
                                 disallowingMinesNear safeLocation: Location
    ) -> Board {
        guard totalNumberOfMines > 0 else {
            // If they want an empty board, they get an empty board
            return Board.empty(size: size)
        }
        
        let size = size.greaterThanZero
        var board = Board.empty(size: size)
        let safeLocation = Size.Index(safeLocation)
        
        size.shuffled()
            .discarding(where: { $0.isTouching(safeLocation, tolerance: 1) })
            .onlyFirst(totalNumberOfMines)
            .map(IntPoint.init)
            .forEach { point in
                board.content[point].giveMine()
            }
        
        return board
    }
    
    
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
