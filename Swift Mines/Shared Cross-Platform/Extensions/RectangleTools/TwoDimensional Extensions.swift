//
//  TwoDimensional Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import RectangleTools
import MultiplicativeArithmetic



public extension TwoDimensional where Length: ExpressibleByIntegerLiteral, Length: Comparable {
    /// Guarantees that what is returned has both measurements greater than zero
    ///
    /// If both of the dimensions are greater than zero, this returns an unchanged copy. Else, this returns a copy
    /// where either/both dimensions which are less than or equal to zero are replaced with `1`.
    var greaterThanZero: Self {
        Self.init(measurementX: max(1, measurementX),
                  measurementY: max(1, measurementY))
    }
}



public extension TwoDimensional where Length: Comparable {
    /// Returns the minimum of the two measurements
    @inlinable
    var minMeasurement: Length {
        return min(measurementX, measurementY)
    }
    
    
    /// Returns the maximum of the two measurements
    @inlinable
    var maxMeasurement: Length {
        return max(measurementX, measurementY)
    }
}



public extension TwoDimensional where Length: MultiplicativeArithmetic {
    
    /// Returns the product of multiplying both measurements
    var product: Length {
        return measurementX * measurementY
    }
}
