//
//  BoardSquare + Image.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-18.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

#if canImport(AppKit)
import Cocoa
#elseif canImport(UIKit)
import Cocoa
#endif

import CrossKitTypes
import RectangleTools



internal extension BoardSquare.Annotated {
    
    func imageForUi(size: CGSize) -> NativeImage {
        
        let imageWhichNeedsToBeResized: NativeImage
        
        switch (self.base.externalRepresentation, self.mineContext) {
        case (.blank, _),
             (.revealed(reason: _), .clear(.farFromMine)):
            return .blank()
            
        case (.revealed(reason: _), .clear(let distance)):
            return .number(forClearSquareAtDistance: distance, size: UIntSize(size))
            
        case (.flagged(style: .sure), _):
            imageWhichNeedsToBeResized = .minesIcon(.flag)
            
        case (.flagged(style: .unsure), _):
            imageWhichNeedsToBeResized = .minesIcon(.questionMark)
            
        case (.revealed(reason: .manual), .mine):
            switch self.base.content {
            case .mine:
                imageWhichNeedsToBeResized = .minesIcon(.detonatedMine)
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return .blank()
            }
            
        case (.revealed(reason: .safelyRevealedAfterWin), .mine),
             (.revealed(reason: .chainReaction), .mine):
            switch self.base.content {
            case .mine:
                imageWhichNeedsToBeResized = .minesIcon(.revealedMine)
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return .blank()
            }
        }
        
        imageWhichNeedsToBeResized.size = size
        return imageWhichNeedsToBeResized
    }
}
