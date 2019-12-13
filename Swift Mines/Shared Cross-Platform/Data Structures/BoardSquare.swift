//
//  BoardSquare.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import RectangleTools



// MARK: - Basics

/// A single square on a Mines board
public struct BoardSquare {
    
    /// Allows this square to be identified across runtimes
    public let id: UUID
    
    /// The content of the board square, whether or not the square has been revealed
    public var content: Content
    
    /// The way the square is currently represented to the user
    public var externalRepresentation: ExternalRepresentation
}



// MARK: Functionality

public extension BoardSquare {
    
    /// `true` iff this square’s content indicates a mine
    @inline(__always)
    var hasMine: Bool { content.hasMine }
    
    
    /// If this square does not contain a mine, then it is made to have one
    @inline(__always)
    mutating func giveMine() {
        content.giveMine()
    }
    
    
    /// Mutates this square so that it's represented with a flag
    ///
    /// - Parameter style: The style of the flag to place
    mutating func placeFlag(style: ExternalRepresentation.FlagStyle) {
        print("Placing a", style, "flag")
        switch externalRepresentation {
        case .blank,
             .flagged(style: _):
            self.externalRepresentation = .flagged(style: style)
            
        case .revealed(reason: _):
            assertionFailure("Attempted to place a flag on a square whose content was already revealed")
        }
    }
    
    
    /// Mutates this square so that its flag is the next flag style
    mutating func cycleFlag() {
        print("Cycling flag...")
        switch externalRepresentation {
        case .blank:
            print("    Cycling to a Flag")
            self.externalRepresentation = .flagged(style: .sure)
            
        case .flagged(style: .sure):
            print("    Cycling to a Question Mark")
            self.externalRepresentation = .flagged(style: .unsure)
            
        case .flagged(style: .unsure):
            print("    Cycling to a Blank")
            self.externalRepresentation = .blank
            
        case .revealed(reason: _):
            assertionFailure("Attempted to place a flag on a square whose content was already revealed")
        }
    }
    
    
    /// Mutates this board square so its contents are revealed
    ///
    /// - Parameter reason: The reason why you want to reveal the contents
    mutating func reveal(reason: RevealReason) {
        self.externalRepresentation = .revealed(reason: reason)
    }
    
    
    /// Returns a copy of this board square with its contents revealed
    ///
    /// - Parameter reason: The reason why you want to reveal the contents
    func revealed(reason: RevealReason) -> Self {
        var copy = self
        copy.reveal(reason: reason)
        return copy
    }
}



// MARK: - Content

public extension BoardSquare {
    
    /// The content of a board square
    enum Content: String {
        
        /// The square is clear; there is no mine
        case clear
        
        /// The square has a mine within it
        case mine
    }
}



// MARK: Functionality

public extension BoardSquare.Content {
    /// `true` iff this square's content indicates a mine
    var hasMine: Bool {
        switch self {
        case .clear: return false
        case .mine: return true
        }
    }
    
    
    /// If this content does not have a mine, then it is made to have one
    mutating func giveMine() {
        switch self {
        case .clear: self = .mine
        case .mine: return
        }
    }
}



// MARK: - ExternalRepresentation

public extension BoardSquare {
    
    /// The way a square is represented to the user
    enum ExternalRepresentation {
        
        /// The square is blank; it is neither flagged nor revealed
        case blank
        
        /// The square has a flag on it
        /// - Parameter style: The style of the flag
        case flagged(style: FlagStyle)
        
        /// The square has been revealed
        /// - Parameter content: The revealed content of the square
        case revealed(reason: RevealReason)
    }
}



// MARK: - FlagStyle

public extension BoardSquare.ExternalRepresentation {
    
    /// The style of a flag on a square
    enum FlagStyle: String {
        
        /// The flag is styled to indicate that the player is unsure whether this square has a mine
        case unsure
        
        /// The flag is styled to indicate that the user is sure that this square has a mine
        case sure
    }
}



// MARK: - Annotated

public extension BoardSquare {
    
    /// A board square after some runtime decisions have been annotated onto it
    struct Annotated {
        
        /// The square without any annotations
        public var base: BoardSquare
        
        /// The style that was inherited from this square's board
        public var inheritedStyle: Board.Style
        
        /// The context of the mine (or lack thereof) in this square
        public var mineContext: MineContext
        
        /// The last known location of this square on the board
        public var cachedLocation: UIntPoint
    }
}


// MARK: Identifiable

extension BoardSquare.Annotated: Identifiable {
    public var id: UUID { base.id }
}


// MARK: Functionality

public extension BoardSquare.Annotated {
    
    /// `true` iff this square’s content indicates a mine
    @inlinable
    var hasMine: Bool {
        self.base.hasMine
    }
    
    
    /// Mutates this board square so its contents are revealed
    ///
    /// - Parameter reason: The reason why you want to reveal the contents
    mutating func reveal(reason: BoardSquare.RevealReason) {
        self.base.reveal(reason: reason)
    }
    
    
    /// Returns a copy of this board square with its contents revealed
    ///
    /// - Parameter reason: The reason why you want to reveal the contents
    func revealed(reason: BoardSquare.RevealReason) -> Self {
        var copy = self
        copy.reveal(reason: reason)
        return copy
    }
    
    
    /// Mutates this square so that it's represented with a flag
    ///
    /// - Parameter style: The style of the flag to place
    mutating func placeFlag(style: BoardSquare.ExternalRepresentation.FlagStyle) {
        self.base.placeFlag(style: style)
    }
    
    
    /// Mutates this square so that its flag is the next flag style
    mutating func cycleFlag() {
        self.base.cycleFlag()
    }
}



// MARK: - MineContext

public extension BoardSquare {
    
    /// How the board square appears to the user
    enum MineContext {
        
        /// The square does not contain a mine
        case clear(distance: MineDistance)
        
        /// The square houses a mine
        /// - Parameter revealReason: The reason why this mine was revealed, or `nil` if it has not been revealed
        case mine
    }
}



// MARK: - MineDistance

public extension BoardSquare {
    
    /// Describes the distance of this square from a mine, assuming it does not contain a mine
    enum MineDistance: UInt8 {
        
        /// The square is far from any mine
        case farFromMine   = 0
        
        /// The square is close to exactly 1 mine
        case closeTo1Mine  = 1
        
        /// The square is close to exactly 2 mines
        case closeTo2Mines = 2
        
        /// The square is close to exactly 3 mines
        case closeTo3Mines = 3
        
        /// The square is close to exactly 4 mines
        case closeTo4Mines = 4
        
        /// The square is close to exactly 5 mines
        case closeTo5Mines = 5
        
        /// The square is close to exactly 6 mines
        case closeTo6Mines = 6
        
        /// The square is close to exactly 7 mines
        case closeTo7Mines = 7
        
        /// The square is close to exactly 8 mines
        case closeTo8Mines = 8
    }
}



public extension BoardSquare.MineDistance {
    @inline(__always)
    var numberObMinesNearby: UInt8 {
        return rawValue
    }
}



// MARK: - RevealReason

public extension BoardSquare {
    
    /// The reason why a square with a mine has its mine revealed
    enum RevealReason: String {
        
        /// The player manually triggered the mine
        case manuallyTriggered
        
        /// The mine was a part of a chain reaction caused by a manually-triggerd one
        case chainReaction
        
        /// The player successfully completed the game without triggering any mines, so it's being displayed
        case safelyRevealedAfterWin
    }
}



// MARK: - Conformances

extension BoardSquare: Hashable {}
extension BoardSquare.Content: Hashable {}
extension BoardSquare.ExternalRepresentation: Hashable {}
extension BoardSquare.ExternalRepresentation.FlagStyle: Hashable {}
extension BoardSquare.Annotated: Hashable {}
extension BoardSquare.MineContext: Hashable {}
extension BoardSquare.RevealReason: Hashable {}
extension BoardSquare.MineDistance: Hashable {}

extension BoardSquare.Content: CaseIterable {}
extension BoardSquare.ExternalRepresentation.FlagStyle: CaseIterable {}
extension BoardSquare.RevealReason: CaseIterable {}
extension BoardSquare.MineDistance: CaseIterable {}
