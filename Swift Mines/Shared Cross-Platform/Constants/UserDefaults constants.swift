//
//  UserDefaults constants.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



public extension UserDefaults {
    /// Tracks those "Never show this dialog again" checkboxes, and such. This way, if the user wants to reset these,
    /// we just destroy this user default suite.
    static let neverShowAgainStates = UserDefaults(suiteName: "\(Bundle.main.bundleIdentifier ?? "org.bh").neverShowAgain") ?? .standard
}
