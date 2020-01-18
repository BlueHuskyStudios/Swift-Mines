//
//  Comparable Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-25.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import Foundation



public extension Comparable {
    
    /// Clamps this value within the given range.
    ///
    /// If this value is greater than the upper bound, then the upper bound is returned. If it's less than the lower
    /// bound, then the lower bound is returned. Otherwise, it's returned unchanged.
    ///
    /// - Parameter range: The range within which to clamp this value
    func clamped(within range: ClosedRange<Self>) -> Self {
        if range.contains(self) {
            return self
        }
        else if range.lowerBound > self {
            return range.lowerBound
        }
        else {
            return range.upperBound
        }
    }
}
