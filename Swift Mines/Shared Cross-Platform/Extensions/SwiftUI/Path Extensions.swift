//
//  Path Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-21.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension Path {
    /// Applies the transform to all points of the path.
    @inlinable
    mutating func apply(_ transform: CGAffineTransform) {
        self = self.applying(transform)
    }
}
