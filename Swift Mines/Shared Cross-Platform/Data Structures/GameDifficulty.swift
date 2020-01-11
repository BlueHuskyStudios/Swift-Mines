//
//  GameDifficulty.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



public enum GameDifficulty: String {
    case easy         = "Easy"
    case intermediate = "Intermediate"
    case advanced     = "Advanced"
    case custom       = "Custom"
}



extension GameDifficulty: Identifiable {
    public var id: String { rawValue }
}



extension GameDifficulty: CaseIterable {}
extension GameDifficulty: Hashable {}
