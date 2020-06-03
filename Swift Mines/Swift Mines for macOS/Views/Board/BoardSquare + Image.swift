//
//  BoardSquare + Image.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-18.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

#if canImport(AppKit)
import Cocoa
#elseif canImport(UIKit)
import Cocoa
#endif

import CrossKitTypes
import RectangleTools



internal extension BoardSquare.Annotated {
    
    /// Creates an image of the given size which is appropriate for presenting on the UI
    ///
    /// - Parameter size: The dimensions of the image to return
    func imageForUi(size: CGSize) -> NativeImage {
        
        let imageWhichNeedsToBeResized: NativeImage
        
        switch (self.base.externalRepresentation, self.mineContext) {
        case (.blank, _),
             (.revealed(reason: _), .clear(.farFromMine)):
            return .blank()
            
        case (.revealed(reason: _), .clear(let distance)):
            return .number(forClearSquareWithProximity: distance, size: UIntSize(size))
            
        case (.flagged(style: .sure), _):
            imageWhichNeedsToBeResized = .minesIcon(.flag, size: .init(size))
            
        case (.flagged(style: .unsure), _):
            imageWhichNeedsToBeResized = .minesIcon(.questionMark, size: .init(size))
            
        case (.revealed(reason: .manual), .mine):
            switch self.base.content {
            case .mine:
                imageWhichNeedsToBeResized = .minesIcon(.detonatedMine, size: .init(size))
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return .blank()
            }
            
        case (.revealed(reason: .safelyRevealedAfterWin), .mine),
             (.revealed(reason: .chainReaction), .mine):
            switch self.base.content {
            case .mine:
                imageWhichNeedsToBeResized = .minesIcon(.revealedMine, size: .init(size))
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return .blank()
            }
        }
        
        imageWhichNeedsToBeResized.size = size
        return imageWhichNeedsToBeResized
    }
}
