//
//  CGAffineTransform Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-21.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import CoreGraphics



public extension CGAffineTransform {
    /// Applies a horizontal skew transform to this transform
    ///
    /// - Parameter skew: The amount of horizontal skew to apply
    init(skew: CGFloat) {
        self.init(a: 1, b: 0, c: skew, d: 1, tx: 0, ty: 0)
    }
}
