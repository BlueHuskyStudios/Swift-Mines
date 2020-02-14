//
//  UserDefaults extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-13.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



public extension UserDefaults {
    
    /// Whether the user prefers their left and right mouse buttons to be swapped
    var swapRightLeftMouseButton: Bool {
        return bool(forKey: "com.apple.mouse.swapLeftRightButton")
    }
    
    
    /// A semantic way to descrive the user's current mouse handedness preference (left-handed vs right-handed)
    var mouseHandedness: MouseHandedness {
        return swapRightLeftMouseButton
            ? .leftHanded
            : .rightHanded
    }
    
    
    
    /// A semantic way to describe a user's mouse handedness (left-handed vs right-handed)
    enum MouseHandedness {
        /// The mouse is held in the right hand. The left button is the primary button, and the right button is the
        /// secondary. "Right-click" is the secondary click, typically summoning a menu.
        case rightHanded
        
        /// The mouse is held in the left hand. The right button is the primary button, and the left button is the
        /// secondary. "Left-click" is the secondary click, typically summoning a menu.
        case leftHanded
        
        
        /// The mouse is held in the right hand. The left button is the primary button, and the right button is the
        /// secondary. "Right-click" is the secondary click, typically summoning a menu.
        public static let leftButtonIsPrimary = rightHanded
        
        /// The mouse is held in the left hand. The right button is the primary button, and the left button is the
        /// secondary. "Left-click" is the secondary click, typically summoning a menu.
        public static let rightButtonIsPrimary = leftHanded
        
        
        /// The user's current mouse handedness preference
        ///
        /// - Parameter defaults: _optional_ - The set of user defaults from which to read. Defaults to `.standard`.
        @inlinable
        public static func current(in defaults: UserDefaults = .standard) -> MouseHandedness {
            return defaults.mouseHandedness
        }
    }
}
