//
//  BoardSquare + Realized Style.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-18.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import CrossKitTypes



internal extension BoardSquare.Annotated {
    func appropriateBackgroundColor() -> NativeColor {
        switch self.base.externalRepresentation {
        case .blank,
             .flagged(style: _):
            return inheritedStyle.baseColor
            
        case .revealed:
            return inheritedStyle.baseColor.withSystemEffect(.pressed)
        }
    }
}
