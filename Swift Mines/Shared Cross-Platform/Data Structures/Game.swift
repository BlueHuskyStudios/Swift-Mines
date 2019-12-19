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
    public let id: UUID
    public var board: Board.Annotated
    public var playState: PlayState
}



extension Game: Identifiable {}
extension Game: Hashable {}


// MARK: Functionality

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
    
    
    /// "Dig" up the square at the given location. If it's a mine, the game is lost. If it's clear, then more info
    /// about the mines is revealed.
    ///
    /// - Parameter location: The location where to dig
    private mutating func dig(at location: UIntPoint) {
        print("Digging at", location)
        if board.hasMine(at: location) {
            loseGame(detonatedMineLocation: location)
        }
        else {
            print("Revealing square")
            board.revealSquare(at: location, reason: .manuallyTriggered)
        }
    }
    
    
    
    private mutating func loseGame(detonatedMineLocation: UIntPoint) {
        print("Board has a mine at \(detonatedMineLocation)! Game over")
        board.revealAll(reason: .chainReaction)
        board.content[detonatedMineLocation].base.reveal(reason: BoardSquare.RevealReason.manuallyTriggered)
        playState = .loss
    }
    
    
    private mutating func placeFlag(style: NextFlagStyle, at location: UIntPoint) {
        switch style {
        case .specific(let style):
            board.content[location].placeFlag(style: style)
        
        case .automatic:
            board.content[location].cycleFlag()
        }
    }
}



// MARK: - PlayState

public extension Game {
    enum PlayState {
        case notStarted
        case playing
        case win
        case loss
    }
}



extension Game.PlayState: Hashable {}



// MARK: - UserAction

public extension Game {
    
    /// An action the user took while playing
    enum UserAction {
        
        /// The user dug at the spot, either revelaing a mine or a place where there was no mine
        case dig
        
        /// The user placed a flag on a spot, either declaring that there is a mine there, or noting it for later
        ///
        /// - Parameter style: The style of flag to place
        case placeFlag(style: NextFlagStyle)
    }
    
    
    
    /// Which flag style to use next
    enum NextFlagStyle {
        
        /// Use a specific flag style next
        case specific(style: BoardSquare.ExternalRepresentation.FlagStyle)
        
        /// Automatically choose a flag style based on the current flag
        case automatic
    }
}
