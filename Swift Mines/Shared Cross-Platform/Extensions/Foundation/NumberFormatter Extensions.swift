//
//  NumberFormatter Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-13.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation



public extension NumberFormatter {
    
    /// Mutates this number formater so that it allows or denies floating-point numbers
    ///
    /// - Parameter shouldAllow: Whether to allow floats
    /// - Returns: `self`
    func allowFloats(_ shouldAllow: Bool) -> Self {
        self.allowsFloats = shouldAllow
        return self
    }
    
    
    /// Mutates this number formater so that it covers the given range
    ///
    /// - Parameter newRange: The range of numbers to cover
    /// - Returns: `self`
    func range<BI>(_ newRange: ClosedRange<BI>) -> Self
        where BI: BinaryInteger
    {
        self.minimum = NSNumber(value: Int(newRange.lowerBound))
        self.maximum = NSNumber(value: Int(newRange.upperBound))
        return self
    }
    
    
    /// Mutates this number formater so that it covers the given range
    ///
    /// - Parameter newRange: The range of numbers to cover
    /// - Returns: `self` 
    func range<BI>(_ newRange: ClosedRange<BI>) -> Self
        where BI: BinaryFloatingPoint
    {
        self.minimum = NSNumber(value: CGFloat.NativeType(newRange.lowerBound))
        self.maximum = NSNumber(value: CGFloat.NativeType(newRange.upperBound))
        return self
    }
}
