//
//  BoardSquare + Realized Style.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-18.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import CrossKitTypes



internal extension BoardSquare.Annotated {
    /// Uses the square, its inherited style, and its current fields, to determine the best color to show behind it
    func appropriateBackgroundColor() -> NativeColor {
        switch self.base.externalRepresentation {
        case .blank,
             .flagged(style: _):
            return inheritedStyle.accentColor
            
        case .revealed:
            #if canImport(UIKit)
            return inheritedStyle.accentColor.withAlphaComponent(0.5)
            #elseif canImport(AppKit)
            return inheritedStyle.accentColor.withSystemEffect(.pressed)
            #else
            #error("UIKit or AppKit required")
            #endif
        }
    }
}
