//
//  Path Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-21.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import SwiftUI



public extension Path {
    /// Applies the transform to all points of the path.
    @inlinable
    mutating func apply(_ transform: CGAffineTransform) {
        self = self.applying(transform)
    }
}
