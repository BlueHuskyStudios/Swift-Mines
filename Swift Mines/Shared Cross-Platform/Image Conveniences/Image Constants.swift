//
//  Image Constants.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import CrossKitTypes
import RectangleTools



public extension NativeImage {
    
    @inline(__always)
    private static var cache: NSCache<GeneratedImageCacheKey, NativeImage> { .generatedBoardImages }
    
    
    private static func cacheKey(identifier: MinesIconIdentifier, size: UIntSize) -> GeneratedImageCacheKey {
        GeneratedImageCacheKey(representedConcept: .iconIdentifier(identifier: identifier), size: size)
    }
    
    
    /// Returns one of a predefined set of icons for a game of Mines
    ///
    /// - Parameters:
    ///   - identifier: The identifier for a Mines icon
    ///   - size:       The size of the resulting image
    static func minesIcon(_ identifier: MinesIconIdentifier, size: UIntSize, style: Board.Style) -> NativeImage {
        return cache.object(forKey: cacheKey(identifier: identifier, size: size))
            ?? (self.init(named: identifier.rawValue)?
                .tintedAsNecessary(as: identifier, size: size, style: style)
                ?? assertionFailure("No \(identifier.rawValue) image in assets", backupValue: .swatch(color: identifier.backupColor)))
    }
    
    
    
    /// Identifies a Mines icon
    enum MinesIconIdentifier: String {
        
        /// A flag that the user palced where they are sure there's a mine
        case flag = "Flag"
        
        /// A question mark that the user placed where they think there might be a mine
        case questionMark = "Question Mark"
        
        /// A mine which has been clicked on and detonated
        case detonatedMine = "Mine (Detonated)"
        
        /// A mine which has been revealed, perhaps in a chain explosion
        case revealedMine = "Mine (Revealed)"
    }
}



private extension NativeImage {
    
    /// If necessary, returns a tinted copy of this image
    ///
    /// - Parameter identifier: The identifier of some mines icon to tint
    func tintedAsNecessary(
        as identifier: MinesIconIdentifier,
        flipped: Bool = defaultFlipped,
        size: UIntSize,
        style: Board.Style
    ) -> NativeImage {
        switch identifier {
        case .flag:
            return tinted(with: style.accentColor, alphaMaskedColor: .white, flipped: flipped, size: size)

        case .questionMark, .detonatedMine, .revealedMine:
            return self
        }
    }
}



private extension NativeImage.MinesIconIdentifier {
    
    /// A color to use in case the dev forgot to put a Mines icon in the bundle, or in case it can't be loaded for some reason
    var backupColor: NativeColor {
        switch self {
        case .flag: return .lightGray
        case .questionMark: return .systemPurple
        case .detonatedMine: return .systemRed
        case .revealedMine: return .black
        }
    }
}
