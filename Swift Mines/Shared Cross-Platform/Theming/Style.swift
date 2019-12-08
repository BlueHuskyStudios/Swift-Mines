//
//  Style.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-05.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa
import CrossKitTypes



public extension Board {
    struct Style {
        var baseColor: NativeColor
        var pattern: Pattern
    }
}



public extension Board.Style {
    enum Pattern {
        case solid
        case checkerboard
    }
}



// MARK: - Conformances

extension Board.Style: Hashable {}



// MARK: - Default

public extension Board.Style {
    
    static let `default` = Self.init(baseColor: .init(hue: (210/360), saturation: 0.74, brightness: 0.64, alpha: 1),
                                     pattern: .checkerboard)
}
