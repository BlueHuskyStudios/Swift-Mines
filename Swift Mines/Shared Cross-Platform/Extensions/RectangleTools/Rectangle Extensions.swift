//
//  Rectangle Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-18.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import RectangleTools
import MultiplicativeArithmetic



public extension Rectangle where Self.Length: ExpressibleByIntegerLiteral {
    /// Returns this rectangle placed with its origin at (0, 0)
    var withOriginZero: Self {
        Self.init(origin: .zero, size: size)
    }
}



public extension Rectangle
    where
        Length: AdditiveArithmetic,
        Length: MultiplicativeArithmetic,
        Length: Comparable
{
    func relative(xPercent: Length, yPercent: Length) -> Point {
        Point.init(x: (self.minX + self.maxX) * xPercent,
                   y: (self.minY + self.maxY) * yPercent)
    }
    
    
    func maxX(yPercentage: Length) -> Point {
        Point.init(x: self.maxX,
                   y: (self.minY + self.maxY) * yPercentage)
    }
    
    
    func minX(yPercentage: Length) -> Point {
        Point.init(x: self.minX,
                   y: (self.minY + self.maxY) * yPercentage)
    }
    
    
    func maxY(xPercentage: Length) -> Point {
        Point.init(x: (self.minX + self.maxX) * xPercentage,
                   y: self.maxY)
    }
    
    
    func minY(xPercentage: Length) -> Point {
        Point.init(x: (self.minX + self.maxX) * xPercentage,
                   y: self.minY)
    }
}
