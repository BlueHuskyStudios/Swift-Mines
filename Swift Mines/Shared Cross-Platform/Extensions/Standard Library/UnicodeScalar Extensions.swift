//
//  UnicodeScalar Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-27.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation



extension UnicodeScalar: Strideable {
    
    public typealias Stride = Int32
    
    
    
    /// The number of sclars between this and the other, such that the distance between `U+0020` and `U+0022` is `2`
    ///
    /// - Parameter other: Another scalar at some distance
    public func distance(to other: UnicodeScalar) -> Stride {
        return Stride(self.value.distance(to: other.value))
    }
    
    
    /// Advances this Unicode scalar by the given amount, such that `U+0020` advanced by `2` is `U+0022`
    ///
    /// - Parameter stride: The amount by which to advance this scalar
    public func advanced(by stride: Stride) -> UnicodeScalar {
        return UnicodeScalar(self.value.advanced(by: Stride.Stride(stride)))!
    }
}
