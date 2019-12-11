//
//  BoardSquare + random.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-05.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension BoardSquare {
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



public extension BoardSquare.Content {
    static func random() -> BoardSquare.Content {
        return allCases.randomElement()!
    }
}



public extension BoardSquare.ExternalRepresentation {
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
    static func random() -> BoardSquare.ExternalRepresentation.FlagStyle {
        return allCases.randomElement()!
    }
}



public extension BoardSquare.RevealReason {
    static func random() -> Self {
        switch (1...3).randomElement() {
        case 1: return .chainReaction
        case 2: return .manuallyTriggered
        case 3: return .safelyRevealedAfterWin
        default: preconditionFailure("Random selection out of range")
        }
    }
}



//public extension BoardSquare.RevealedContent {
//    static func random(hasMine: Bool) -> Self {
//        if hasMine {
//            return .mine(revealReason: .random())
//        }
//        else {
//            switch (0...8).randomElement() {
//            case 0: return .farFromMine
//            case 1: return .closeTo1Mine
//            case 2: return .closeTo2Mines
//            case 3: return .closeTo3Mines
//            case 4: return .closeTo4Mines
//            case 5: return .closeTo5Mines
//            case 6: return .closeTo6Mines
//            case 7: return .closeTo7Mines
//            case 8: return .closeTo8Mines
//            default: preconditionFailure("Random selection out of range")
//            }
//        }
//    }
//}
//
//
//
//public extension BoardSquare.ExternalRepresentation.MineRevealReason {
//    static func random() -> BoardSquare.ExternalRepresentation.MineRevealReason {
//        return allCases.randomElement()!
//    }
//}
