//
//  Style.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-05.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

#if canImport(UIKit)
import UIKit
#endif
import CrossKitTypes



public extension Board {
    
    /// The style of a board
    struct Style {
        
        /// The color of things on the board, like flags
        var accentColor: NativeColor
        
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
    
    static let `default` = systemAccentColor
    
    static let plain = Self.init(accentColor: .plainBaseColor, pattern: .solid)
    
    static let systemAccentColor = Self.init(accentColor: .tintColor, pattern: .solid)
    
    static let blue = Self.init(accentColor: .init(hue: (210/360),
                                                 saturation: 0.74,
                                                 brightness: 0.64,
                                                 alpha: 1),
                                     pattern: .solid)
}



internal extension NativeColor {
    static var plainBaseColor: NativeColor {
        #if canImport(UIKit)
            return .systemFill
        #elseif canImport(AppKit)
            return .controlColor
        #endif
    }
    
    
    static var tintColor: NativeColor {
        #if canImport(UIKit)
        return UIView().tintColor
        #elseif canImport(AppKit)
        return .controlAccentColor
        #endif
    }
}
