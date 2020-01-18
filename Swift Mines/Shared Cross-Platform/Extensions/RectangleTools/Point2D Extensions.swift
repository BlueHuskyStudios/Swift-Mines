//
//  Point2D Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-19.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import RectangleTools



public extension Point2D {
    var humanReadableDescription: String { "(\(x), \(y))" }
}



public extension Point2D where Length: FixedWidthInteger {
    
    /// Determines whether this point is touching the given one
    ///
    /// - Parameters:
    ///   - other:     The point to check which might touch this one
    ///   - inclusive: _optional_ - Iff `true`, then this returns `true` when `self == other`. Either value will not
    ///                 affect how this function looks at adjacent locations
    ///   - tolerance: The number of squares away from this one which are considered "touching", where `0` means only
    ///                this square (if `inclusive`), `1` means this square (if `inclusive`) and the 8 squares around
    ///                it, `2` means this square (if `inclusive`), the 8 squares around it, and the 16 squares around
    ///                those, etc.
    func isTouching(_ other: Self, inclusive: Bool = true, tolerance: UInt = 1) -> Bool { // TODO: Test
        
        func isTouchingInclusively() -> Bool {
            return abs(x.distance(to: other.x)) <= tolerance
                && abs(y.distance(to: other.y)) <= tolerance
        }
        
        if inclusive {
            return isTouchingInclusively()
        }
        else {
            return !isCoLocated(with: other)
                && isTouchingInclusively()
        }
    }
}



public extension Point2D where Length: Equatable {
    
    /// Returns `true` iff this point is co-located with the given one
    /// - Parameter other: Another point which might be where this one is
    func isCoLocated(with other: Self) -> Bool { // TODO: Test
        return other.x == self.x && other.y == self.y
    }
}
