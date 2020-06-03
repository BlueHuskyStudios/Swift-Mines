//
//  Character Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-27.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation



public extension Character {
    /// Returns the toggled case of this character.
    ///
    /// ```swift
    /// Character("A").togglingCase() // "a"
    /// Character("a").togglingCase() // "A"
    /// Character("7").togglingCase() // "7"
    /// ```
    func togglingCase() -> String {
        if isLowercase {
            return uppercased()
        }
        else if isUppercase {
            return lowercased()
        }
        else {
            return description
        }
    }
}
