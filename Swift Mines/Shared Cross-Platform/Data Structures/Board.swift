//
//  Board.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import Foundation
import RectangleTools
import SafeCollectionAccess
import SafePointer



// MARK: - Protocol

public protocol BoardProtocol {
    associatedtype Square: BoardSquareProtocol
    
    var content: [[Square]] { get }
    
    func neighbors(ofSquareAt location: Location) -> Neighbors
    
    
    
    typealias Neighbors = SquareNeighbors<Square>
}


// MARK: Synthesis

public extension BoardProtocol {
    
    @inlinable
    func neighbors(ofSquareAt location: Location) -> Neighbors {
        neighbors(ofSquareAtRow: Int(location.y), column: Int(location.x))
    }
    
    
    func neighbors(ofSquareAtRow rowIndex: Int, column columnIndex: Int) -> Neighbors {
        Neighbors(
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
    
    
    
    typealias Location = UIntPoint
    typealias Size = UIntSize
}



// MARK: - Basics

/// A game board for Mines
public struct Board {
    
    /// The content of the game board: A grid of unannotated Mines board squares
    public var content: [[BoardSquare]]
}



public extension Board {
    
    /// The number of cells wide and tall
    var size: Size {
        Size(width: UInt(content[0].count), height: UInt(content.count))
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
        public var content: [[BoardSquare.Annotated]] {
            didSet {
                self.size = content.size
            }
        }
        
        /// The size of the board
        var size: Size
        
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
        
        
        init(content: [[BoardSquare.Annotated]], style: Style) {
            self.content = content
            self.style = style
            self.size = content.size
        }
    }
}



public extension Board.Annotated {
    
    var totalNumberOfMines: UInt {
        return UInt(
            self
                .content
                .lazy
                .flatMap { $0 }
                .filter { $0.hasMine }
                .count
        )
    }
    
    
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
    /// - Returns: _discardable_ - The annotated square which was just revealed
    @discardableResult
    internal mutating func revealSquare(at location: UIntPoint, reason: BoardSquare.RevealReason) -> BoardSquare.Annotated {
//        print("Revealing that the square at", location, content[location].hasMine ? "has a mine" : "is clear", "(was previously \(content[location].base.externalRepresentation))")
        content[location].reveal(reason: reason)
        return content[location]
    }
    
    
    /// Reveals all the squares touching the given one which are far from mines (touching 0 mine squares), and all the
    /// squares those touch.
    ///
    /// - Note: It is a precondition that the given location not already have a mine. If it does have a mine, this
    ///         function will do nothing.
    ///
    /// - Parameters:
    ///   - startingLocation:                  The first square to reveal. Iff this is touching 0 mines, then all of
    ///                                        its neighbors are also revealed. This process repeats for all neighbors
    ///                                        which are touching 0 mines.
    ///   - stopIfThisSquareIsAlreadyRevealed: _optional_ - Iff `true`, then this function will not continue if the
    ///                                        square at the given location is already revealed
    internal mutating func revealClearSquares(touching startingLocation: UIntPoint,
                                              stopIfThisSquareIsAlreadyRevealed: Bool = false) {
        let square = content[startingLocation]
        
//        guard stopIfThisSquareIsAlreadyRevealed ? !square.isRevealed : true else {
//            return
//        }

        revealSquare(at: startingLocation, reason: .chainReaction)
        
        switch square.mineContext {
        case .clear(distance: .farFromMine):
            self.neighbors(ofSquareAt: startingLocation)
                .discardingNilElements()
                .discarding { $0.isRevealed }
                .forEach { neighborSquare in
                    revealClearSquares(touching: neighborSquare.cachedLocation,
                                       stopIfThisSquareIsAlreadyRevealed: true)
                }
            
        case .clear(distance: _):
            break // Nothing to do?
            
        case .mine:
            assertionFailure("This function should not be called upon a square with a mine")
            return
        }
    }
}


// MARK: BoardProtocol

extension Board.Annotated: BoardProtocol {}



extension Board.Annotated: Hashable {}



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
}


// MARK: BoardProtocol

extension Board: BoardProtocol {}



// MARK: - SquareNeighbors

public struct SquareNeighbors<NeighborType: BoardSquareProtocol> {
    
    public let top: Neighbor
    public let topRight: Neighbor
    public let right: Neighbor
    public let bottomRight: Neighbor
    public let bottom: Neighbor
    public let bottomLeft: Neighbor
    public let left: Neighbor
    public let topLeft: Neighbor
    
    
    
    public typealias Neighbor = NeighborType?
}



private extension SquareNeighbors {
    
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
}



public extension SquareNeighbors {
    
    /// Finds the number of neighbors which contain a mine
    func numberOfNeighborsWithMines() -> UInt8 {
        return self                             // Given all neighbors of a particular cell on the game board
            .lazy                               // Evaluate all the following steps in only 1 loop
            .discardingNilElements()            // Discard any neighbors which are off the board
            .map { $0.content.hasMine ? 1 : 0 } // If it has a mine, treat it as a `1`, otherwise a `0`
            .summed()                           // Add them all up!
    }
    
    
    
    /// Finds the number of neighbors which contain a mine
    func numberOfNeighborsWithMines_procedural() -> UInt8 {
        
        var returnValue: UInt8 = 0
        
        for neighbor in self {
            if neighbor != nil && neighbor!.content.hasMine {
                returnValue += 1
            }
        }
        
        return returnValue
    }
}



extension SquareNeighbors: Sequence {
    
    public var underestimatedCount: Int { 8 }
    
    
    public func makeIterator() -> Array<Neighbor>.Iterator {
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
    
    static func random(size: Size) -> Board {
        return Board(content: size.map2D { _ in
            BoardSquare.random()
        })
    }
}
