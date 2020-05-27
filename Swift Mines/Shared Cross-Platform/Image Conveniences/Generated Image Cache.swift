//
//  Generated Image Cache.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-07.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import CoreGraphics
import RectangleTools
import CrossKitTypes


// Some convenient constants for use in the cache. These should be self-explanatory. If they're not, please file a bug:
// https://GitHub.com/BlueHuskyStudios/Swift-Mines/issues/new

private let presumedTallestScreenResolution = 2880
private let presumedEasiestBoardNumberOfVerticalSquares = 4
private let presumedBiggestSquareVerticalResolution = presumedTallestScreenResolution / presumedEasiestBoardNumberOfVerticalSquares
private let presumedBiggestSquarePixelCount = presumedBiggestSquareVerticalResolution * presumedBiggestSquareVerticalResolution
private let presumedMostPixelsToStoreEightSquareImages = presumedBiggestSquarePixelCount * 8
private let percentHeadroomToSaveForNewDataBeforeEjectingCachedItems = CGFloat(0.20)
private let maxCacheCost = Int(CGFloat(presumedMostPixelsToStoreEightSquareImages) * (1 + percentHeadroomToSaveForNewDataBeforeEjectingCachedItems))



internal extension NSCache where KeyType == GeneratedImageCacheKey, ObjectType == NativeImage {
    
    /// The app-wide cache of generated number images
    static let generatedBoardImages: NSCache<GeneratedImageCacheKey, NativeImage> = {
        let cache = NSCache<GeneratedImageCacheKey, NativeImage>()
        cache.totalCostLimit = maxCacheCost
        return cache
    }()
}



// MARK: GeneratedImageCacheKey

/// A key used to store and fetch a number image into the number image cache
internal class GeneratedImageCacheKey {
    
    /// The concept the image represents
    let representedConcept: RepresentedConcept
    
    let tint: NativeColor?
    
    /// The dimensions of the image
    let size: UIntSize
    
    
    /// Creates a new cache key
    init(representedConcept: RepresentedConcept,
         tint: NativeColor? = nil,
         size: UIntSize) {
        self.representedConcept = representedConcept
        self.tint = tint
        self.size = size
    }
}



internal extension GeneratedImageCacheKey {
    /// The concept represented by an image that's been cached with a particular key
    enum RepresentedConcept {
        
        /// A generated number image for the given number of neighboring mines
        ///
        /// - Parameter proximity: The number of mines nearby
        case generatedNumber(proximity: BoardSquare.MineProximity)
        
        /// An icon from a bundle asset
        case iconIdentifier(identifier: NativeImage.MinesIconIdentifier)
    }
}



extension GeneratedImageCacheKey.RepresentedConcept: Hashable {}



extension GeneratedImageCacheKey: Equatable {
    static func == (lhs: GeneratedImageCacheKey, rhs: GeneratedImageCacheKey) -> Bool {
        return lhs.representedConcept == rhs.representedConcept
            && lhs.tint == rhs.tint
            && lhs.size == rhs.size
    }
}



extension GeneratedImageCacheKey: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(representedConcept)
        hasher.combine(tint)
        hasher.combine(size)
    }
}
