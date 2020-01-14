//
//  CGAffineTransform Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-21.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import CoreGraphics



public extension CGAffineTransform {
    init(skew: CGFloat) {
        self.init(a: 1, b: 0, c: skew, d: 1, tx: 0, ty: 0)
    }
}
