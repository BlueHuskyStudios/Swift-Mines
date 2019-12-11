//
//  Size2D Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import RectangleTools
import MultiplicativeArithmetic



public extension Size2D where Length: Comparable {
    
    /// Returns the minimum of the two side lengths
    @inline(__always)
    var minSideLength: Length { minMeasurement }
    
    /// Returns the maximum of the two side lengths
    @inline(__always)
    var maxSideLength: Length { maxMeasurement }
}



public extension Size2D where Length: MultiplicativeArithmetic {
    
    /// Returns the product of multiplying both measurements
    @inline(__always)
    var area: Length {
        return product
    }
}
