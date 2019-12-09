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



public extension NativeImage {
    
    static func number(forClearSquareAtDistance distance: BoardSquare.MineDistance, size: UIntSize) -> NativeImage {
        let number = NativeImage(size: .init(size))
        number.inCurrentGraphicsContext { number, context in
            context.setFillColor(NativeColor.green.cgColor) // TODO: remove
            NSAttributedString(string: distance.numberObMinesNearby.description)
                .draw(in: CGRect(origin: .zero, size: number.size))
        }
        return number
    }
}



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



// MARK: - NumberImageCacheKey

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
