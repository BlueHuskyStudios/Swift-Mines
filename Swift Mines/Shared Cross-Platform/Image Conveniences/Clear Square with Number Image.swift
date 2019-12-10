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
    
    static func number(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage {
        cachedNumberImage(forClearSquareAtDistance: distance, size: size)
        ?? generateAndCacheNumberImage(forClearSquareAtDistance: distance, size: size)
    }
    
    
    private static func cachedNumberImage(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage? {
        cacheForImagesOfBoardSquareNumbers.object(forKey: NumberImageCacheKey(distance: distance, size: size))
    }
    
    
    private static func generateAndCacheNumberImage(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage {
        let image = generateNumberImage(forClearSquareAtDistance: distance, size: size)
        cacheForImagesOfBoardSquareNumbers.setObject(
            image,
            forKey: NumberImageCacheKey(distance: distance, size: size),
            cost: cost(forGeneratedNumberImageOfSize: size)
        )
        return image
    }
    
    
    private static func generateNumberImage(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage {
        let size = CGSize(size.greaterThanZero)
        let number = NativeImage(size: size)
        number.size = size
        let fontSize = size.minSideLength * (3/4)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        number.inCurrentGraphicsContext { number, context in
            let attributedString =
                NSMutableAttributedString(string: distance.numberObMinesNearby.description,
                                   attributes:
                    [
                        .font : NativeFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold),
                        .paragraphStyle : paragraphStyle,
                        .foregroundColor : distance.numberFillColor,
                        .strokeColor : NativeColor.white,
                        .strokeWidth : fontSize / 16
                    ]
                )
            
            attributedString.draw(in: CGRect(origin: .zero, size: size))
            
            attributedString.removeAttribute(.strokeWidth, range: NSRange(location: 0, length: attributedString.length))
            attributedString.draw(in: CGRect(origin: .zero, size: size))
        }
        return number
    }
    
    
    private static func cost(forGeneratedNumberImageOfSize size: UIntSize) -> Int {
        return Int(size.area)
    }
}



// MARK: - Convenience Extensions

private extension BoardSquare.MineDistance {
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
    
    
    private var colorName: NativeColor.Name {
        return "Color for mine distance \(rawValue)"
    }
}



// MARK: - Cache

private let cacheForImagesOfBoardSquareNumbers: NSCache<NumberImageCacheKey, NativeImage> = {
    let cache = NSCache<NumberImageCacheKey, NativeImage>()
    cache.totalCostLimit = maxCacheCost
    return cache
}()

private let presumedTallestScreenResolution = 2880
private let presumedEasiestBoardNumberOfVerticalSquares = 10
private let presumedBiggestSquareVerticalResolution = presumedTallestScreenResolution / presumedEasiestBoardNumberOfVerticalSquares
private let presumedBiggestSquarePixelCount = presumedBiggestSquareVerticalResolution * presumedBiggestSquareVerticalResolution
private let presumedMostPixelsToStoreEightSquareImages = presumedBiggestSquarePixelCount * 8
private let maxCacheCost = Int(CGFloat(presumedMostPixelsToStoreEightSquareImages) * 1.2)



// MARK: NumberImageCacheKey

private class NumberImageCacheKey {
    let distance: BoardSquare.MineDistance
    let size: UIntSize
    
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
