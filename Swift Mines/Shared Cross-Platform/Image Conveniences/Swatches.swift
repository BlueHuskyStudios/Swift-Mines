//
//  Swatches.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

#if canImport(UIKit)
import UIKit
#endif

import Foundation
import CoreGraphics
import CrossKitTypes
import RectangleTools
import SimpleLogging



public extension NativeImage {
    
    enum Scale {
        case autoRetina
        case pixelPerfect
        case custom(scale: CGFloat)
        
        
        var valueForCoreGraphics: CGFloat {
            switch self {
            case .autoRetina: return 0
            case .pixelPerfect: return 1
            case .custom(scale: let scale): return scale
            }
        }
    }
}



public extension NativeImage {
    /// Generates a rectangular image which is entirely solidly the given color
    ///
    /// - Parameters:
    ///   - color:  The color of the swatch
    ///   - size:   _optional_ - The size of the swatch. Defaults to (1 × 1)
    ///   - opaque: _optional_ - Whether the resulting image should be without an alpha layer. Defaults to `false`
    ///   - scale:  _optional_ - The DPI of the resulting image. Defaults to `autoRetina`
    ///
    /// - Returns: A swatch with the given parameters, or a blank image if no image can be drawn at this time
    static func swatch(
        color: NativeColor,
        size: UIntSize = UIntSize(width: 1, height: 1),
        opaque: Bool = false,
        scale: Scale = .autoRetina
    ) -> NativeImage
    {
        let size = CGSize(size)
        
        #if canImport(UIKit)
            
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale.valueForCoreGraphics)
            defer { UIGraphicsEndImageContext() }
            color.set()
            UIRectFill(CGRect(origin: .zero, size: size))
            return UIGraphicsGetImageFromCurrentImageContext() ?? NativeImage()
        
        #elseif canImport(AppKit)
        
            let image = NativeImage(size: size)
            do {
                try image.inCurrentGraphicsContext { image, context in
                    guard let context = context else { return }
                    context.setFillColor(color.cgColor)
                    context.fill(CGRect(origin: .zero, size: image.size))
                }
            }
            catch {
                log(error: error)
            }
            return image
        
        #endif
    }
    
    
    /// Generates a blank (transparent) image of the given size
    ///
    /// - Parameter size: The size of the resulting image
    /// - Returns: A clear/transparent/blank image
    static func blank(size: UIntSize = UIntSize(width: 1, height: 1)) -> NativeImage {
        self.swatch(color: .clear, size: size)
    }
}
