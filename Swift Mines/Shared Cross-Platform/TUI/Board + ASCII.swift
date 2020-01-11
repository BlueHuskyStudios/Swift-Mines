//
//  Board + ASCII.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-10.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



public extension Board.Annotated {
    func asAsciiText() -> String {
        return content.asAsciiTextGrid { square -> Character.ASCII in
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
                    case .clear(distance: .farFromMine):
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
