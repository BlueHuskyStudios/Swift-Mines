//
//  Clear Square with Number Image.swift
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
import UIKit.NSParagraphStyle
#elseif canImport(AppKit)
import AppKit.NSParagraphStyle
#else
#error("UIKit or AppKit required")
#endif



public extension NativeImage {
    
    @inline(__always)
    private static var cache: NSCache<GeneratedImageCacheKey, NativeImage> { .generatedBoardImages }
    
    
    private static func cacheKey(proximity: BoardSquare.MineProximity, size: UIntSize) -> GeneratedImageCacheKey {
        GeneratedImageCacheKey(representedConcept: .generatedNumber(proximity: proximity), size: size)
    }
    
    
    /// Generates an image with the number appropriate for the given distance from a mine.
    ///
    /// - Note: A cache is kept so that if such an image has already been generated, it is returned
    ///
    /// - Parameters:
    ///   - proximity: The proximity to be represented in the returned image
    ///   - size:      The dimensions of the resulting image
    ///
    /// - Returns: An image of the given size representing the given distance from a mine
    static func number(forClearSquareWithProximity proximity: BoardSquare.MineProximity, size: UIntSize) -> NativeImage {
        cachedNumberImage(forClearSquareWithProximity: proximity, size: size)
            ?? generateAndCacheNumberImage(forClearSquareWithProximity: proximity, size: size)
    }
    
    
    /// Fetches the cached image for the given distance at the given size.
    /// If the cache has no such image, `nil` is returned.
    ///
    /// - Parameters:
    ///   - proximity: The proximity to be represented in the returned image
    ///   - size:      The dimensions of the resulting image
    ///
    /// - Returns: A cached image of the given size representing the given distance from a mine, or `nil` if no such
    ///            image has been cached
    private static func cachedNumberImage(forClearSquareWithProximity proximity: BoardSquare.MineProximity, size: UIntSize) -> NativeImage? {
        cache.object(forKey: cacheKey(proximity: proximity, size: size))
    }
    
    
    /// Generates an image of the given size for the given distance, and immediately caches it
    ///
    /// - Parameters:
    ///   - proximity: The proximity to be represented in the returned image
    ///   - size:      The dimensions of the resulting image
    ///
    /// - Returns: An image of the given size representing the given distance from a mine
    private static func generateAndCacheNumberImage(forClearSquareWithProximity proximity: BoardSquare.MineProximity, size: UIntSize) -> NativeImage {
        let image = generateNumberImage(forClearSquareWithProximity: proximity, size: size)
        cache.setObject(
            image,
            forKey: cacheKey(proximity: proximity, size: size),
            cost: cost(forGeneratedNumberImageOfSize: size)
        )
        return image
    }
    
    
    /// Generates an image of the given size for the given distance
    ///
    /// - Parameters:
    ///   - proximity: The proximity to be represented in the returned image
    ///   - size:      The dimensions of the resulting image
    private static func generateNumberImage(forClearSquareWithProximity proximity: BoardSquare.MineProximity, size: UIntSize) -> NativeImage {
        let number = NativeImage.blank(size: size)
        let size = CGSize(size.greaterThanZero)
        let fontSize = size.minSideLength * (3/4)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        number.inCurrentGraphicsContext { number, context in
            let attributedString =
                NSMutableAttributedString(string: proximity.numberOfMinesNearby.description,
                                          attributes:
                    [
                        .font : NativeFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold),
                        .paragraphStyle : paragraphStyle,
                        .foregroundColor : proximity.numberFillColor,
                        .strokeColor : NativeColor.white,
                        .strokeWidth : NSNumber(value: (fontSize / 4).native)
                    ]
            )
            
            attributedString.draw(in: CGRect(origin: .zero, size: size))
            
            attributedString.removeAttribute(.strokeWidth, range: NSRange(location: 0, length: attributedString.length))
            attributedString.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return number
    }
    
    
    /// Estimates the cost of generating an image of the given size
    ///
    /// - Parameter size: The dimensions of an image to generate
    /// - Returns: The cost of generating such an image
    private static func cost(forGeneratedNumberImageOfSize size: UIntSize) -> Int {
        return Int(size.area)
    }
}



// MARK: - Convenience Extensions

private extension BoardSquare.MineProximity {
    
    /// The color with which to fill a number representing this distance
    var numberFillColor: NativeColor {
        switch self {
        case .farFromMine:
            return .clear
            
        case .closeTo1Mine,
             .closeTo2Mines,
             .closeTo3Mines,
             .closeTo4Mines,
             .closeTo5Mines,
             .closeTo6Mines,
             .closeTo7Mines,
             .closeTo8Mines:
            return NativeColor(named: colorName)
                ?? assertionFailure("No asset color for \(rawValue)", backupValue: .magenta)
        }
    }
    
    
    /// The name of a color asset to use to represent this distance
    private var colorName: NativeColor.Name {
        return "Color for mine distance \(rawValue)"
    }
}
