//
//  NativeImage Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-08.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import CrossKitTypes
import RectangleTools
import SimpleLogging

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else
#error("Either UIKit or AppKit required")
#endif



public extension NativeImage {
    #if canImport(UIKit) || canImport(WatchKit)
    /// The default "flipped" drawing context of the current target OS. That is, whether to flip the Y axis of the
    /// graphics context so that positive is downward. This is `false` in macOS with AppKit, and `true` in the newer
    /// Apple platforms UIKit and WatchKit.
    static let defaultFlipped = true
    #elseif canImport(AppKit)
    /// The default "flipped" drawing context of the current target OS. That is, whether to flip the Y axis of the
    /// graphics context so that positive is downward. This is `false` in macOS with AppKit, and `true` in the newer
    /// Apple platforms UIKit and WatchKit.
    static let defaultFlipped = false
    #else
    #error("Could not infer default 'flipped' drawing context for the target platform")
    #endif
}



public extension NativeImage {
    
    #if canImport(UIKit)
    convenience init(
        size: CGSize,
        flipped drawingHandlerShouldBeCalledWithFlippedContext: Bool,
        drawingHandler: @escaping (CGRect) throws -> Bool
    ) rethrows
    {
        guard let cgImage = CGImage.new(size: size) else {
            fatalError("Could not make empty image")
        }
        
        self.init(cgImage: cgImage)
        do {
            let rect = CGRect(origin: .zero, size: size)
            try inCurrentGraphicsContext(withFocus: true) { image, context in
                context?.draw(cgImage, in: rect)
                _ = try drawingHandler(rect)
            }
        }
        catch {
            log(error: error)
            throw error
        }
    }
    #endif
    
    
    /// Executes the given function while this image has draw context focus,
    /// and automatically unlocks that focus after the block is done
    ///
    /// - Parameters:
    ///   - flipped: _optional_ -`true` if the drawing context should be flipped, otherwise `false`.
    ///              Defaults to the platform's default.
    ///   - operation: The operation to perform while this image has context focus
    ///
    /// - Returns: Anything the given function throws
    ///
    /// - Throws: Anything the given function throws
    func withFocus<Return>(do operation: (_ image: NativeImage) throws -> Return) rethrows -> Return {
        #if canImport(AppKit)
        self.lockFocus()
        defer { self.unlockFocus() }
        #endif
        return try operation(self)
    }
    
    
    /// Executes the given function while this image has draw context focus,
    /// and automatically unlocks that focus after the block is done
    ///
    /// - Parameters:
    ///   - flipped: _optional_ -`true` if the drawing context should be flipped, otherwise `false`.
    ///              Defaults to the platform's default.
    ///   - operation: The operation to perform while this image has context focus
    ///
    /// - Returns: Anything the given function throws
    ///
    /// - Throws: Anything the given function throws
    func withFocus<Return>(flipped: Bool, do operation: (_ image: NativeImage) throws -> Return) rethrows -> Return {
        #if canImport(AppKit)
        self.lockFocusFlipped(flipped)
        defer { self.unlockFocus() }
        #endif
        return try operation(self)
    }
    
    
    /// Allows you to perform a contextualized draw operation with the current context on this image. The image will
    /// have focus lock while in the given function.
    ///
    /// - Parameters:
    ///   - flipped:   _optional_ - Whether to flip the Y axis of the graphics context. Defaults to `defaultFlipped`.
    ///   - withFocus: _optional_ - Whether to lock focus on the current image before entering the given function.
    ///                Defaults to `true`.
    ///   - operation: The contextualized operation to perform while this image has focus lock
    ///
    /// - Returns: Anything the given function throws
    ///
    /// - Throws: Anything the given function throws, or `InCurrentGraphicsContextError`
    func inCurrentGraphicsContext<Return>(
        flipped: Bool = defaultFlipped,
        withFocus: Bool = true,
        do operation: OperationInGraphicsContext<Return>
    ) rethrows -> Return
    {
        try inGraphicsContext(withFocus: withFocus) { image in
            guard let currentContext = CGContext.current else {
                return try operation(image, nil)
            }
            
            #if canImport(AppKit)
            let priorNsgc = NSGraphicsContext.current
            defer { NSGraphicsContext.current = priorNsgc }
            NSGraphicsContext.current = NSGraphicsContext(cgContext: currentContext, flipped: flipped)
            #else
            UIGraphicsPushContext(currentContext)
            defer { UIGraphicsPopContext() }
            #endif
            
            return try operation(image, currentContext)
        }
    }
    
    
    func inNewGraphicsContext<Return>(
        flipped: Bool = defaultFlipped,
        withFocus: Bool = true,
        do operation: OperationInGraphicsContext<Return>
    ) rethrows -> Return
    {
        try inGraphicsContext(withFocus: withFocus) { image in
            guard let currentContext = CGContext.current else {
                return try operation(image, nil)
            }
            
            #if canImport(AppKit)
            #error("TODO")
            #else
            UIGraphicsBeginImageContextWithOptions(
                /* size: */ size,
                /* opaque: */ cgImage?.alphaInfo == CGImageAlphaInfo.none,
                /* scale: */ scale
            )
            defer { UIGraphicsEndImageContext() }
            #endif
            
            return try operation(image, currentContext)
        }
    }
    
    
    private func inGraphicsContext<Return>(
        withFocus: Bool,
        contextSwitcher: ContextSwitcher<Return>
    ) rethrows -> Return
    {
        if withFocus {
            return try self.withFocus(do: contextSwitcher)
        }
        else {
            return try contextSwitcher(self)
        }
    }
    
    
    
    typealias OperationInGraphicsContext<Return> = (_ image: NativeImage, _ context: CGContext?) throws -> Return
    
    private typealias ContextSwitcher<Return> = (_ image: NativeImage) throws -> Return
}



public extension NativeImage {
    func copy(newSize: CGSize, retina: Bool = true) -> NativeImage? {
        #if canImport(UIKit)
        // In next line, pass 0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(/* size: */ newSize, /* opaque: */ false, /* scale: */ retina ? 0 : 1)
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
        #elseif canImport(AppKit)
        guard let copy = self.copy() as? NativeImage else {
            return nil
        }
        copy.size = newSize
        return copy
        #endif
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
