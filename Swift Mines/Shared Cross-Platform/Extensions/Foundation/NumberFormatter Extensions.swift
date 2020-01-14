//
//  NumberFormatter Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-13.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



public extension NumberFormatter {
    func allowFloats(_ shouldAllow: Bool) -> Self {
        self.allowsFloats = shouldAllow
        return self
    }
    
    
    func range<BI>(_ newRange: ClosedRange<BI>) -> Self
        where BI: BinaryInteger
    {
        self.minimum = NSNumber(value: Int(newRange.lowerBound))
        self.maximum = NSNumber(value: Int(newRange.upperBound))
        return self
    }
    
    
    func range<BI>(_ newRange: ClosedRange<BI>) -> Self
        where BI: BinaryFloatingPoint
    {
        self.minimum = NSNumber(value: CGFloat.NativeType(newRange.lowerBound))
        self.maximum = NSNumber(value: CGFloat.NativeType(newRange.upperBound))
        return self
    }
}
