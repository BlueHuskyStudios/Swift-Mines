//
//  Image Tinting.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-07.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import CoreGraphics
import CrossKitTypes
import RectangleTools
import SimpleLogging



public extension NativeImage {
    
    /// Returns a version of this image with the given tint applied
    ///
    /// - Parameters:
    ///   - color:            The color to apply as a tint to this image
    ///   - alphaMaskedColor: _optional_ - The color to paint beneath the alpha mask before applying the tint. This is
    ///                       not always necessary; only use this if the tinting would otherwise result in a
    ///                       tint-colored halo around the image. If so, specify a color that is close to the color
    ///                       around the border of the image. Otherwise, `nil` means to not apply this color at all.
    ///                       Defaults to `nil`.
    ///   - flipped:          _optional_ - Specifies whether to draw with a flipped Y axis (where positive values
    ///                       increase downward).
    ///                       Defaults to `defaultFlipped`
    ///   - size:             _optional_ - The estimated size of the image. Outside this function, this is not usually
    ///                       necessary when the source is vectorized, like PDFs. However, when the eventual on-screen
    ///                       representation of the image will be larger than the file's specified dimensions, the
    ///                       generated tint mask is drawn in the native size and appears as a blurry halo around the
    ///                       image. If that happens, or if you're planning to scale a raster image, then pass the
    ///                       estimated final size on-screen (in points) here, and this function will compensate for
    ///                       that. If, however, you're using the image at the size specified in the file's metadata,
    ///                       then passing `nil` means to render the tint mask at the same dimensions as this image.
    ///                       Defaults to `nil`.
    func tinted(with color: NativeColor,
                alphaMaskedColor: NativeColor? = nil,
                flipped: Bool = defaultFlipped,
                size: UIntSize? = nil) -> NativeImage {
        
        let size = size.map(CGSize.init) ?? self.size
        
        return NativeImage(size: size, flipped: flipped) { outputBounds in
            do {
                return try self.inCurrentGraphicsContext(
                    withFocus: false,
                    do: self.maskAndApplyTintWithinContext(
                        tint: color,
                        in: outputBounds,
                        alphaMaskedColor: alphaMaskedColor,
                        flipped: flipped,
                        size: size
                    )
                )
            }
            catch {
                log(error: error)
                return nil!
            }
        }
    }
    
    
    private func maskAndApplyTintWithinContext(
        tint color: NativeColor,
        in outputBounds: CGRect,
        alphaMaskedColor: NativeColor?,
        flipped: Bool,
        size: CGSize
    ) -> ((NativeImage, CGContext?) -> Bool) {{ image, outputContext in
        
        var rect = outputBounds
        guard let outputContext = outputContext else { return false }
        #if canImport(UIKit)
        guard let cgImage = image.cgImage else { return false }
        #elseif canImport(AppKit)
        guard let cgImage = image.cgImage(forProposedRect: &rect, context: nil, hints: nil) else { return false }
        #else
        #error("UIKit or AppKit required")
        #endif
        
        let unmaskedImage = NativeImage(
            size: size,
            flipped: flipped,
            drawingHandler: self.drawingHandler(
                forTint: color,
                in: outputBounds,
                alphaMaskedColor: alphaMaskedColor
            )
        )
        
        outputContext.clip(to: outputBounds, mask: cgImage)
        
        outputContext.setBlendMode(.sourceAtop)
        unmaskedImage.draw(in: outputBounds)
        
        return true
        
    }}
    
    
    private func drawingHandler(
        forTint color: NativeColor,
        in outputBounds: CGRect,
        alphaMaskedColor: NativeColor?
    ) -> ((CGRect) -> Bool) {{ unmaskedBounds in
        
        do {
            return try self.inCurrentGraphicsContext(
                withFocus: false,
                do: self.apply(tint: color, in: outputBounds, alphaMaskedColor: alphaMaskedColor)
            )
        }
        catch {
            log(error: error)
            return false
        }
    }}
    
    
    private func apply(
        tint color: NativeColor,
        in outputBounds: CGRect,
        alphaMaskedColor: NativeColor?
    ) -> ((NativeImage, CGContext?) -> Bool) {{ unmaskedImage, unmaskedContext in
        
        guard let unmaskedContext = unmaskedContext else { return false }
        
        if let alphaMaskedColor = alphaMaskedColor {
            unmaskedContext.setFillColor(alphaMaskedColor.cgColor)
            unmaskedContext.fill(outputBounds)
        }
        
        self.draw(in: outputBounds)
        
        unmaskedContext.setBlendMode(.hue)
        unmaskedContext.setFillColor(color.cgColor)
        unmaskedContext.fill(outputBounds)
        
        return true
    }}
}
