//
//  BoardSquare + random.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-05.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import Foundation



public extension BoardSquare {
    /// Just generates a random board square. No logic nor reason behind this; it'll just be random.
    ///
    /// Good for testing, bad for production.
    static func random() -> BoardSquare {
        let internalContent = Content.random()
        return self.init(id: UUID(),
                         content: internalContent,
                         externalRepresentation: .random())
    }
    
    
    /// Generates a new, clear, and blank board square
    static var empty: BoardSquare {
        return BoardSquare(
            id: UUID(),
            content: .clear,
            externalRepresentation: .blank
        )
    }
}



public extension BoardSquareProtocol.Content {
    /// Simply returns a random board square's content. No logic nor reason behind this; it'll just be random.
    ///
    /// Good for testing, bad for production.
    static func random() -> BoardSquare.Content {
        return allCases.randomElement()!
    }
}



public extension BoardSquare.ExternalRepresentation {
    /// Simply returns a random board square's external representation. No logic nor reason behind this; it'll just be random.
    ///
    /// Good for testing, bad for production.
    static func random() -> BoardSquare.ExternalRepresentation {
        switch (1...3).randomElement() {
        case 1: return .blank
        case 2: return .flagged(style: .random())
        case 3: return .revealed(reason: .random())
        default: preconditionFailure("Random selection out of range")
        }
    }
}



public extension BoardSquare.ExternalRepresentation.FlagStyle {
    /// Simply returns a random board square's flag style. No logic nor reason behind this; it'll just be random.
    ///
    /// Good for testing, bad for production.
    static func random() -> BoardSquare.ExternalRepresentation.FlagStyle {
        return allCases.randomElement()!
    }
}



public extension BoardSquare.RevealReason {
    /// Simply returns a random reason a board square might've been revealed. No logic nor reason behind this; it'll just be random.
    ///
    /// Good for testing, bad for production.
    static func random() -> Self {
        switch (1...3).randomElement() {
        case 1: return .chainReaction
        case 2: return .manual
        case 3: return .safelyRevealedAfterWin
        default: preconditionFailure("Random selection out of range")
        }
    }
}
