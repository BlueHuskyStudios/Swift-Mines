//
//  Board.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import RectangleTools
import SafeCollectionAccess



/// A game board for Mines
public struct Board {
    
    /// The content of the game board: A grid of unannotated Mines board squares
    var content: [[BoardSquare]]
}



public extension Board {
    
    /// The number of cells wide and tall
    var size: UIntSize {
        UIntSize(width: UInt(content[0].count), height: UInt(content.count))
    }
    
    
    /// Finds the square at the given location, or the one on the wall closest to it
    ///
    /// - Parameter location: The location of the square on the board
    func square(at location: UIntPoint) -> BoardSquare {
        return content[clamping: Int(location.y)]?[clamping: Int(location.x)]
            ?? assertionFailure("Empty board?", backupValue: BoardSquare.empty)
    }
    
    
    /// Determines whether there is a mine at the given location
    ///
    /// - Parameter location: The location of a potential mine
    @inlinable
    func hasMine(at location: UIntPoint) -> Bool {
        square(at: location).hasMine
    }
}



// MARK: - Annotated

public extension Board {
    
    /// A board after additional info has been annotated upon it
    struct Annotated {
        
        /// The content of this board; all of the squares and info annotated upon them
        var content: [[BoardSquare.Annotated]]
        
        /// How this board and its squares are styled
        var style: Style {
            didSet {
                content.enumerated().forEach { (rowIndex, row) in
                    row.enumerated().forEach { (boardSquareIndex, _) in
                        content[rowIndex][boardSquareIndex].inheritedStyle = style
                    }
                }
            }
        }
    }
}



public extension Board.Annotated {
    /// Returns a copy of this board, with all the squares revealed
    func allRevealed(reason: BoardSquare.RevealReason) -> Self {
        Self.init(
            content: self.content.map { row in
                row.map { square in
                    square.revealed(reason: reason)
                }
            },
            style: self.style
        )
    }
    
    
    /// Mutates this board so that all the squares revealed
    mutating func revealAll(reason: BoardSquare.RevealReason) {
        self = allRevealed(reason: reason)
    }
    
    
    /// Finds the square at the given location, or the one on the wall closest to it
    ///
    /// - Parameter location: The location of the square on the board
    func square(at location: UIntPoint) -> BoardSquare.Annotated {
        guard let square = content[clamping: Int(location.y)]?[clamping: Int(location.x)] else {
            fatalError("Empty board?")
        }
        return square
    }
    
    
    /// Finds the square at the given location, or the one on the wall closest to it
    ///
    /// - Parameter location: The location of the square on the board
    mutating func mutateSquare(at location: UIntPoint, with mutator: (inout BoardSquare.Annotated) -> Void) {
        guard var square = content[clamping: Int(location.y)]?[clamping: Int(location.x)] else {
            assertionFailure("Empty board?")
            return
        }
        
        mutator(&square)
        
        content[location] = square
    }
    
    
    /// Determines whether there is a mine at the given location
    ///
    /// - Parameter location: The location of a potential mine
    func hasMine(at location: UIntPoint) -> Bool {
        square(at: location).hasMine
    }
    
    
    /// Mutates this board so that the square at the given location is revealed
    ///
    /// - Parameter location: The location of the square to be revealed
    internal mutating func revealSquare(at location: UIntPoint, reason: BoardSquare.RevealReason) {
        content[location].reveal(reason: reason)
    }
}



public extension Board {
    /// Processes and annotates this whole board to prepare it for play
    ///
    /// - Parameter baseStyle: The style to apply to each square
    func annotated(baseStyle: Style) -> Annotated {
        Annotated(content: annotatedContent(baseStyle: baseStyle),
                  style: baseStyle)
    }
    
    
    private func annotatedContent(baseStyle: Style) -> [[BoardSquare.Annotated]] {
        content
            .enumerated()
            .map { (rowIndex, row) in
                row
                    .enumerated()
                    .map { (columnIndex, boardSquare) in
                        annotate(square: boardSquare,
                                 atRow: rowIndex,
                                 column: columnIndex,
                                 style: baseStyle)
                }
            }
    }
    
    
    private func annotate(square: BoardSquare,
                          atRow rowIndex: Int,
                          column columnIndex: Int,
                          style: Style
    ) -> BoardSquare.Annotated {
        BoardSquare.Annotated(
            base: square,
            inheritedStyle: style,
            mineContext: findMineContext(
                ofSquare: square,
                atRow: rowIndex,
                column: columnIndex
            ),
            cachedLocation: UIntPoint(x: UInt(columnIndex), y: UInt(rowIndex))
        )
    }
    
    
    private func findMineContext(ofSquare square: BoardSquare,
                                 atRow rowIndex: Int,
                                 column columnIndex: Int
    ) -> BoardSquare.MineContext {
        let neighbors = self.neighbors(ofSquareAtRow: rowIndex, column: columnIndex)
        
        switch square.content {
        case .mine:
            return .mine
            
        case .clear:
            return neighbors.mineContextAssumingCenterIsClear()
        }
    }
    
    
    private func neighbors(ofSquareAtRow rowIndex: Int, column columnIndex: Int) -> SquareNeighbors {
        SquareNeighbors(
            top:         content[orNil: rowIndex - 1]?[orNil: columnIndex    ],
            topRight:    content[orNil: rowIndex - 1]?[orNil: columnIndex + 1],
            right:       content[orNil: rowIndex    ]?[orNil: columnIndex + 1],
            bottomRight: content[orNil: rowIndex + 1]?[orNil: columnIndex + 1],
            bottom:      content[orNil: rowIndex + 1]?[orNil: columnIndex    ],
            bottomLeft:  content[orNil: rowIndex + 1]?[orNil: columnIndex - 1],
            left:        content[orNil: rowIndex    ]?[orNil: columnIndex - 1],
            topLeft:     content[orNil: rowIndex - 1]?[orNil: columnIndex - 1]
        )
    }
    
    
    
    fileprivate struct SquareNeighbors {
        
        let top: Neighbor
        let topRight: Neighbor
        let right: Neighbor
        let bottomRight: Neighbor
        let bottom: Neighbor
        let bottomLeft: Neighbor
        let left: Neighbor
        let topLeft: Neighbor
        
        
        
        typealias Neighbor = BoardSquare?
    }
}



private extension Board.SquareNeighbors {
    
    /// Determines the context of the square at the center of these neighbors,
    /// assuming that square does not have a mine
    func mineContextAssumingCenterIsClear() -> BoardSquare.MineContext {
        
        let neighboringMineCount = self.numberOfNeighborsWithMines()
        
        guard let distance = BoardSquare.MineDistance(rawValue: neighboringMineCount) else {
            assertionFailure("Attempted to 0...8 mines around square, but got \(neighboringMineCount)")
            return .clear(distance: .closeTo8Mines)
        }
        
        return .clear(distance: distance)
    }
    
    
    /// Finds the number of neighbors which contain a mine
    private func numberOfNeighborsWithMines() -> UInt8 {
        return self                             // Given all neighbors of a particular cell on the game board
            .lazy                               // Evaluate all the following steps in only 1 loop
            .compactMap { $0 }                  // Discard any neighbors which are off the board
            .map { $0.content.hasMine ? 1 : 0 } // If it has a mine, treat it as a `1`, otherwise a `0`
            .reduce(into: 0, +=)                // Add them all up!
    }
}



extension Board.SquareNeighbors: Sequence {
    
    var underestimatedCount: Int { 8 }
    
    
    func makeIterator() -> Array<Neighbor>.Iterator {
        return [
                top,
                topRight,
                right,
                bottomRight,
                bottom,
                bottomLeft,
                left,
                topLeft,
            ]
            .makeIterator()
    }
}



// MARK: - Convenience initializers

public extension Board {
    
    static func random(size: UIntSize) -> Board {
        return Board(content: size.map2D { _ in
            BoardSquare.random()
        })
    }
}
