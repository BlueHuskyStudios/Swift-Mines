//
//  Swatches.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import CrossKitTypes
import RectangleTools



public extension NativeImage {
    
    /// Generates a rectangular image which is entirely solidly the given color
    ///
    /// - Parameters:
    ///   - color: The color of the swatch
    ///   - size:  _optional_ - The size of the swatch. Defaults to (1 × 1)
    static func swatch(color: NativeColor, size: UIntSize = UIntSize(width: 1, height: 1)) -> Self {
        let `self` = self.init(size: .init(size))
        self.inCurrentGraphicsContext { `self`, context in
            guard let context = context else { return }
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: self.size))
        }
        return self
    }
    
    
    /// Generates a blank (transparent) image of the given size
    ///
    /// - Parameter size: The size of the resulting image
    /// - Returns: A clear/transparent/blank image
    static func blank(size: UIntSize = UIntSize(width: 1, height: 1)) -> NativeImage {
        self.swatch(color: .clear, size: size)
    }
}
