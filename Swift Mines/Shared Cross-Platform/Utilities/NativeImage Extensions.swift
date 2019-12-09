//
//  NativeImage Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-08.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import CrossKitTypes
import RectangleTools

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else
#error("Either UIKit or AppKit required")
#endif



public extension NativeImage {
    
    /// Generates a blank (transparent) image of the given size
    ///
    /// - Parameter size: The size of the resulting image
    /// - Returns: A clear/transparent/blank image
    static func blank(size: UIntSize = UIntSize(width: 1, height: 1)) -> NativeImage {
        let size = CGSize(width: Int(size.width), height: Int(size.height))
        let blank = NativeImage(size: size)
        blank.withFocus { blank in
            guard let context = CGContext.current else {
                return
            }

            context.setFillColor(.clear)
            context.clear(CGRect(origin: .zero, size: size))
        }
        return blank
    }
    
    
    /// Executes the given function while this image has draw context focus,
    /// and automatically unlocks that focus after the block is done
    ///
    /// - Parameters:
    ///   - flipped: _optional_ -`true` if the drawing context should be flipped, otherwise `false`.
    ///              Defaults to the platform's default.
    ///   - operation: The operation to perform while this image has context focus
    /// - Throws: Anything the given function throws
    func withFocus(do operation: (_ image: NativeImage) throws -> Void) rethrows {
        self.lockFocus()
        try operation(self)
        self.unlockFocus()
    }
    
    
    /// Executes the given function while this image has draw context focus,
    /// and automatically unlocks that focus after the block is done
    ///
    /// - Parameters:
    ///   - flipped: _optional_ -`true` if the drawing context should be flipped, otherwise `false`.
    ///              Defaults to the platform's default.
    ///   - operation: The operation to perform while this image has context focus
    /// - Throws: Anything the given function throws
    func withFocus(flipped: Bool, do operation: (_ image: NativeImage) throws -> Void) rethrows {
        self.lockFocusFlipped(flipped)
        try operation(self)
        self.unlockFocus()
    }
    
    
    /// Allows you to perform a contextualized draw operation with the current context on this image. The image will
    /// have focus lock while in the given function.
    ///
    /// - Parameter operation: The contextualized operation to perform while this image has focus lock
    func inCurrentGraphicsContext(do operation: (_ image: NativeImage, _ context: CGContext) throws -> Void) rethrows {
        try withFocus { focusedImage in
            guard let context = CGContext.current else {
                return
            }
            
            try operation(focusedImage, context)
        }
    }
}



private extension CGContext {
    static var current: CGContext? {
        #if canImport(UIKit)
        return UIGraphicsGetCurrentContext()
        #elseif canImport(AppKit)
        return NSGraphicsContext.current?.cgContext
        #endif
    }
}
