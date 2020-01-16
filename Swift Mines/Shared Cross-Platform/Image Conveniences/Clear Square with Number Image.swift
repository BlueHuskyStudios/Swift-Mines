//
//  Clear Square with Number Image.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-08.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import CrossKitTypes
import RectangleTools

#if canImport(UIKit)
import UIKit.NSParagraphStyle
#elseif canImport(AppKit)
import AppKit.NSParagraphStyle
#else
#error("UIKit or AppKit required")
#endif



public extension NativeImage {
    
    /// Generates an image with the number appropriate for the given distance from a mine.
    ///
    /// - Note: A cache is kept so that if such an image has already been generated, it is returned
    ///
    /// - Parameters:
    ///   - distance: The distance to be represented in the returned image
    ///   - size:     The dimensions of the resulting image
    ///
    /// - Returns: An image of the given size representing the given distance from a mine
    static func number(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage {
        cachedNumberImage(forClearSquareAtDistance: distance, size: size)
            ?? generateAndCacheNumberImage(forClearSquareAtDistance: distance, size: size)
    }
    
    
    /// Fetches the cached image for the given distance at the given size.
    /// If the cache has no such image, `nil` is returned.
    ///
    /// - Parameters:
    ///   - distance: The distance to be represented in the returned image
    ///   - size:     The dimensions of the resulting image
    ///
    /// - Returns: A cached image of the given size representing the given distance from a mine, or `nil` if no such
    ///            image has been cached
    private static func cachedNumberImage(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage? {
        cacheForImagesOfBoardSquareNumbers.object(forKey: NumberImageCacheKey(distance: distance, size: size))
    }
    
    
    /// Generates an image of the given size for the given distance, and immediately caches it
    ///
    /// - Parameters:
    ///   - distance: The distance to be represented in the returned image
    ///   - size:     The dimensions of the resulting image
    ///
    /// - Returns: An image of the given size representing the given distance from a mine
    private static func generateAndCacheNumberImage(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage {
        let image = generateNumberImage(forClearSquareAtDistance: distance, size: size)
        cacheForImagesOfBoardSquareNumbers.setObject(
            image,
            forKey: NumberImageCacheKey(distance: distance, size: size),
            cost: cost(forGeneratedNumberImageOfSize: size)
        )
        return image
    }
    
    
    /// Generates an image of the given size for the given distance
    ///
    /// - Parameters:
    ///   - distance: The distance to be represented in the returned image
    ///   - size:     The dimensions of the resulting image
    private static func generateNumberImage(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage {
        let size = CGSize(size.greaterThanZero)
        let number = NativeImage(size: size)
        number.size = size
        let fontSize = size.minSideLength * (3/4)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        number.inCurrentGraphicsContext { number, context in
            let attributedString =
                NSMutableAttributedString(string: distance.numberOfMinesNearby.description,
                                   attributes:
                    [
                        .font : NativeFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold),
                        .paragraphStyle : paragraphStyle,
                        .foregroundColor : distance.numberFillColor,
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

private extension BoardSquare.MineDistance {
    
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



// MARK: - Cache

/// The app-wide cache of generated number images
private let cacheForImagesOfBoardSquareNumbers: NSCache<NumberImageCacheKey, NativeImage> = {
    let cache = NSCache<NumberImageCacheKey, NativeImage>()
    cache.totalCostLimit = maxCacheCost
    return cache
}()


// Some convenient constants for use in the cache. These should be self-explanatory. If they're not, please file a bug:
// https://GitHub.com/BenLeggiero/Swift-Mines/issues/new

private let presumedTallestScreenResolution = 2880
private let presumedEasiestBoardNumberOfVerticalSquares = 10
private let presumedBiggestSquareVerticalResolution = presumedTallestScreenResolution / presumedEasiestBoardNumberOfVerticalSquares
private let presumedBiggestSquarePixelCount = presumedBiggestSquareVerticalResolution * presumedBiggestSquareVerticalResolution
private let presumedMostPixelsToStoreEightSquareImages = presumedBiggestSquarePixelCount * 8
private let maxCacheCost = Int(CGFloat(presumedMostPixelsToStoreEightSquareImages) * 1.2)



// MARK: NumberImageCacheKey

/// A key used to store and fetch a number image into the number image cache
private class NumberImageCacheKey {
    
    /// The distance the image represents
    let distance: BoardSquare.MineDistance
    
    /// The dimensions of the image
    let size: UIntSize
    
    
    /// Creates a new cache key
    init(distance: BoardSquare.MineDistance,
         size: UIntSize) {
        self.distance = distance
        self.size = size
    }
}



extension NumberImageCacheKey: Equatable {
    static func == (lhs: NumberImageCacheKey, rhs: NumberImageCacheKey) -> Bool {
        return lhs.distance == rhs.distance
            && lhs.size == rhs.size
    }
}



extension NumberImageCacheKey: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(distance)
        hasher.combine(size)
    }
}
