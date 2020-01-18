//
//  OverallAppState.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-09.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import SwiftUI



/// The overall state of the app. Reading this will let you re-create the runtime from nothing.
public class OverallAppState: ObservableObject {
    
    /// The current game that the player is playing
    @Published
    public var game: Game
    
    /// The current screen that the player is seeing
    @Published
    public var currentScreen = AppScreen.game
    
    
    init(game: Game) {
        self.game = game
    }
}



public extension OverallAppState {
    
    /// The key which represents the app state as a kind of observable object
    static let key = Key.self
    
    
    
    /// The type of key which is used to represent the app state as a kind of observable object
    enum Key: EnvironmentKey {
        
        public typealias Value = OverallAppState
        
        
        
        /// The default app state, if none is yet made
        public static let defaultValue = OverallAppState(game: Game.basicNewGame())
    }
}
