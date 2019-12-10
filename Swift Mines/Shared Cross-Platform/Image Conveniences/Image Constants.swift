//
//  Image Constants.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import CrossKitTypes



public extension NativeImage {
    
    static func minesIcon(_ identifier: MinesIconIdentifier) -> Self {
        self.init(named: identifier.rawValue)
            ?? assertionFailure("No \(identifier.rawValue) image in assets", backupValue: .swatch(color: identifier.backupColor))
    }
    
    
    
    enum MinesIconIdentifier: String {
        case flag = "Flag"
        case questionMark = "Question Mark"
        case detonatedMine = "Mine (Detonated)"
        case revealedMine = "Mine (Revealed)"
    }
}



private extension NativeImage.MinesIconIdentifier {
    var backupColor: NativeColor {
        switch self {
        case .flag: return .lightGray
        case .questionMark: return .systemPurple
        case .detonatedMine: return .systemRed
        case .revealedMine: return .black
        }
    }
}
