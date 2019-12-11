//
//  Game.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import RectangleTools



/// Everything we need to know in order to display a game of Mines while it's being played
public struct Game {
    var board: Board.Annotated
    var playState: PlayState
}



public extension Game {
    enum PlayState {
        case notStarted
        case playing
        case win
        case loss
    }
}



public extension Game {
    /// An action the user took while playing
    enum UserAction {
        
        /// The user dug at the spot, either revelaing a mine or a place where there was no mine
        case dig
        
        /// The user placed a flag on a spot, either declaring that there is a mine there, or noting it for later
        ///
        /// - Parameter style: The style of flag to place, or `nil` to cycle based on the current flag
        case placeFlag(style: FlagStyle?)
    }
    
    
    
    typealias FlagStyle = BoardSquare.ExternalRepresentation.FlagStyle
}



public extension Game {
    /// Mutates the game board to reflect the result of the user taking the given action at the given location
    ///
    /// - Parameters:
    ///   - action:   The action the user took
    ///   - location: The location of the action
    mutating func updateBoard(after action: UserAction, at location: UIntPoint) {
        switch action {
        case .dig: dig(at: location)
        case .placeFlag(let style): placeFlag(style: style, at: location)
        }
    }
    
    
    private mutating func dig(at location: UIntPoint) {
        if board.hasMine(at: location) {
            loseGame(detonatedMineLocation: location)
        }
        else {
            board.revealSquare(at: location, reason: .manuallyTriggered)
        }
    }
    
    
    
    private mutating func loseGame(detonatedMineLocation: UIntPoint) {
        board.revealAll(reason: .chainReaction)
        board.content[detonatedMineLocation].base.reveal(reason: BoardSquare.RevealReason.manuallyTriggered)
        playState = .loss
    }
    
    
    private mutating func placeFlag(style: FlagStyle?, at location: UIntPoint) {
        if let style = style {
            board.content[location].placeFlag(style: style)
        }
        else {
            board.content[location].cycleFlag()
        }
    }
}
