//
//  AppScreen.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-10.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



/// A major screen of this app
public enum AppScreen {
    
    /// The primary game screen
    case game
    
    /// The screen where the user sets up a new game before playing it
    case newGameSetup
    
//    /// The screen where the user can set their preferences for how the app should behave
//    case preferences
//
//    /// The screen where the user can view high scores and stuff
//    case scores
}



public extension AppScreen {
    
    /// The screen to go to when it's ambiguous which to go to next. For instance, when the app is first run or when
    /// the user completes a dialog.
    static let `default` = game
}
