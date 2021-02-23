//
//  Board + ASCII.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-10.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation



public extension Board.Annotated {
    /// Converts this board to ASCII art
    ///
    /// ## Example:
    /// ```
    /// +---+---+---+---+---+---+---+---+---+---+
    /// |   |   | 1 | F | 1 | 1 | . | . | . | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// |   |   | 1 | 1 | 2 | 2 | ? | . | . | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// |   |   |   |   | 1 | F | 2 | 1 | 1 | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// |   |   |   |   | 1 | 1 | 1 |   | 1 | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// |   |   |   |   |   |   |   |   | 1 | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// | 2 | 2 | 1 |   |   |   |   | 1 | 1 | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// | F | F | 1 |   |   |   | 1 | 2 | F | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// | 2 | 2 | 1 |   |   | 1 | 2 | F | . | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// |   | 1 | 1 | 1 |   | 1 | F | . | . | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// |   | 1 | F | 1 |   | 1 | . | . | . | . |
    /// +---+---+---+---+---+---+---+---+---+---+
    /// ```
    func asAsciiText() -> String {
        return content.asAsciiTextGrid { square in
            return { () -> Character in
                switch square.base.externalRepresentation {
                case .blank:
                    return "."
                    
                case .flagged(style: .sure):
                    return "F"
                    
                case .flagged(style: .unsure):
                    return "?"
                    
                case .revealed(let reason):
                    switch square.mineContext {
                    case .clear(proximity: .farFromMine):
                        return " "
                        
                    case .clear(let distance):
                        return distance.numberOfMinesNearby.description.first!
                        
                    case .mine:
                        switch reason {
                        case .chainReaction,
                             .safelyRevealedAfterWin:
                            return "*"
                            
                        case .manual:
                            return "X"
                        }
                    }
                }
            }().asciiValue!
        }
    }
}
