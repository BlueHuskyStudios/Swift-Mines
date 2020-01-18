//
//  Image Constants.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import Foundation
import CrossKitTypes



public extension NativeImage {
    
    /// Returns one of a predefined set of icons for a game of Mines
    ///
    /// - Parameter identifier: The identifier for a Mines icon
    static func minesIcon(_ identifier: MinesIconIdentifier) -> Self {
        self.init(named: identifier.rawValue)
            ?? assertionFailure("No \(identifier.rawValue) image in assets", backupValue: .swatch(color: identifier.backupColor))
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
