//
//  Style.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-05.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Cocoa
import CrossKitTypes



public extension Board {
    
    /// The style of a board
    struct Style {
        
        /// The color of the board
        var baseColor: NativeColor
        
        /// The pattern which uses the base color
        var pattern: Pattern
    }
}



public extension Board.Style {
    
    /// A pattern for the board
    enum Pattern {
        
        /// No pattern; use a solid color
        case solid
        
//        /// A simple checkerboard pattern
//        case checkerboard
    }
}



// MARK: - Conformances

extension Board.Style: Hashable {}



// MARK: - Default

public extension Board.Style {
    
    static let `default` = plain
    
    static let plain = Self.init(baseColor: .controlColor, pattern: .solid)
    
    static let systemAccentColor = Self.init(baseColor: .controlAccentColor, pattern: .solid)
    
    static let blue = Self.init(baseColor: .init(hue: (210/360), saturation: 0.74, brightness: 0.64, alpha: 1),
                                     pattern: .solid)
}
