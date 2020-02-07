//
//  OobeState.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-05.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI
import UserDefault
//import SemVer



/// The state of the out-of-the-box experience (first run and after an update)
public struct OobeState {
        
    @UserDefault("shouldShowDisclaimer", defaults: .neverShowAgainStates)
    var shouldShowDisclaimer = true
    
//    @UserDefault
//    var mostRecentVersionReleaseNotesSeen: SemVer
    
    
    private init() {}
}



public extension OobeState {
    
    static let shared = OobeState()
}
