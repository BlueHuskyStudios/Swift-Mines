//
//  Rectangle Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-18.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import RectangleTools



public extension Rectangle where Self.Length: ExpressibleByIntegerLiteral {
    /// Returns this rectangle placed with its origin at (0, 0)
    var withOriginZero: Self {
        Self.init(origin: .zero, size: size)
    }
}
