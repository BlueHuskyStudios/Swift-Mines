//
//  Comparable Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-25.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension Comparable {
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
