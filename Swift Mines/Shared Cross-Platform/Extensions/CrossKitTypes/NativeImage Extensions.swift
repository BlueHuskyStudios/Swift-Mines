//
//  NativeImage Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-08.
//  Copyright © 2019 Ben Leggiero BH-1-PS
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
    
    /// Executes the given function while this image has draw context focus,
    /// and automatically unlocks that focus after the block is done
    ///
    /// - Parameters:
    ///   - flipped: _optional_ -`true` if the drawing context should be flipped, otherwise `false`.
    ///              Defaults to the platform's default.
    ///   - operation: The operation to perform while this image has context focus
    ///
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
    ///
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
    
    /// Returns the current `CGContext`
    ///
    /// The current graphics context is `nil` by default. Prior to calling its `drawRect` method, view objects push a
    /// valid context onto the stack, making it current.
    ///
    ///
    /// # UIKit Only:
    /// If you are not using a `UIView` object to do your drawing, you must push a valid context onto the stack
    /// manually using the `UIGraphicsPushContext(_:)` function.
    ///
    /// This function may be called from any thread of your app.
    static var current: CGContext? {
        #if canImport(UIKit)
        return UIGraphicsGetCurrentContext()
        #elseif canImport(AppKit)
        return NSGraphicsContext.current?.cgContext
        #endif
    }
}
