//
//  OverallAppState.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-09.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI



public class OverallAppState: ObservableObject {
    
    @Published
    public var game: Game
    
    @Published
    public var currentScreen = AppScreen.game
    
    
    init(game: Game) {
        self.game = game
    }
}



public extension OverallAppState {
    static let key = Key.self
    
    
    
    enum Key: EnvironmentKey {
        
        public typealias Value = OverallAppState
        
        
        
        public static let defaultValue = OverallAppState(game: Game.basicNewGame())
    }
}
