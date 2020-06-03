//
//  AppScreen.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-10.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation



/// A major screen of this app
public enum AppScreen {
    
    /// The primary game screen
    case game
    
    /// The screen where the user sets up a new game before playing it
    case newGameSetup
    
    /// For now, this just tells the user that SwiftUI doesn't support right-click, so you have to Ctrl+Click or
    /// long-click. In future versions, this might be a changelog or something.
    case oobe
    
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
    
    
    /// The screen to show when the app starts. This takes into account any previous app state.
    static func appropriateStartupScreen() -> AppScreen {
        if !OobeState.shared.skipFirstTimeDisclaimer {
            return .oobe
        }
        else {
            return .default
        }
    }
}
