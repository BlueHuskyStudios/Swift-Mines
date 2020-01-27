//
//  GameDifficulty.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import SwiftUI



/// A difficulty that the user can choose without thinking about the board's size and number of mines
public enum PredefinedGameDifficulty: String {
    

    /// The predefined difficulty for an easy game.
    /// A good entry-level difficulty for new players, or those not looking for a challenge.
    case easy         = "Easy"
    
    /// The predefined difficulty for a game of intermediate difficulty.
    /// A good diffigulty for players who've mastered the basics and want to graduate to a more challenging board.
    case intermediate = "Intermediate"
    
    /// The predefined difficulty for a game of advanced difficulty.
    /// A good difficulty for players who've become bored of easier boards and want a bigger challenge.
    case advanced     = "Advanced"
}



public extension PredefinedGameDifficulty {
    
    /// The predefined configuration for a game where no assumptions are made of the player.
    /// A good difficulty for the first board shown to players.
    static let `default` = easy
    
    
    /// The human-readable text to display for the name of this difficulty
    var displayName: LocalizedStringKey { .init(rawValue) }
}



// MARK: - Conformance

extension PredefinedGameDifficulty: Identifiable {
    public var id: String { rawValue }
}



extension PredefinedGameDifficulty: CaseIterable {}
extension PredefinedGameDifficulty: Hashable {}
