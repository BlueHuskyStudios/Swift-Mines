//
//  GameDifficulty.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



public enum PredefinedGameDifficulty: String {
    case easy         = "Easy"
    case intermediate = "Intermediate"
    case advanced     = "Advanced"
}



public extension PredefinedGameDifficulty {
    
    static let `default` = easy
    
    
    var displayName: String { rawValue }
}



extension PredefinedGameDifficulty: Identifiable {
    public var id: String { rawValue }
}



extension PredefinedGameDifficulty: CaseIterable {}
extension PredefinedGameDifficulty: Hashable {}
