//
//  Point2D Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
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
        
//        return Self.init(x: x +~ 0, y: x +~ 1).isCoLocated(with: other) // ↑
//            || Self.init(x: x +~ 1, y: y +~ 1).isCoLocated(with: other) // ↗︎
//            || Self.init(x: x +~ 1, y: y +~ 0).isCoLocated(with: other) // →
//            || Self.init(x: x +~ 1, y: y -~ 1).isCoLocated(with: other) // ↘︎
//            || Self.init(x: x +~ 0, y: y -~ 1).isCoLocated(with: other) // ↓
//            || Self.init(x: x -~ 1, y: y -~ 1).isCoLocated(with: other) // ↙︎
//            || Self.init(x: x -~ 1, y: y +~ 0).isCoLocated(with: other) // ←
//            || Self.init(x: x -~ 1, y: y +~ 1).isCoLocated(with: other) // ↖︎
    }
//
//
//    /// Returns a new point which is at the location of this point with the given shift applied
//    ///
//    /// - Parameters:
//    ///   - 𝚫x: The change in the X coordinate
//    ///   - 𝚫y: The change in the Y coordinate
//    func shifted(𝚫x: Length, 𝚫y: Length) -> Self { // TODO: Test
//        Self.init(
//            x: x + 𝚫x,
//            y: y + 𝚫y
//        )
//    }
//
//
//    /// The ASCII-only version of `shifted(𝚫x:𝚫y:)`
//    ///
//    /// - Parameters:
//    ///   - deltaX: The change in the X coordinate
//    ///   - deltaY: The change in the Y coordinate
//    @inline(__always)
//    func shifted(deltaX: Length, deltaY: Length) -> Self { // TODO: Test
//        shifted(𝚫x: deltaX, 𝚫y: deltaY)
//    }
}



public extension Point2D where Length: Equatable {
    
    /// Returns `true` iff this point is co-located with the given one
    /// - Parameter other: Another point which might be where this one is
    func isCoLocated(with other: Self) -> Bool { // TODO: Test
        return other.x == self.x && other.y == self.y
    }
}
