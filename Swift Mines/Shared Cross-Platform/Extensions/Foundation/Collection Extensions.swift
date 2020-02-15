//
//  Collection Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-10.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation



public extension Collection {
    
    /// Returns a subsequence containing only the first _n_ elements, where `amountToKeep` is _n_
    ///
    /// - Parameter amountToKeep: The amount of elements at the beginning to keep. If this is larger than the number of
    ///                           elements in this collection, then the subsequence contains all the elements.
    /// - Returns: A subsequence only containing the first _n_ elements
    @inlinable
    func onlyFirst(_ amountToKeep: UInt) -> SubSequence {
        dropLast(Swift.max(0, count - Int(amountToKeep)))
    }
    
    
    /// Returns a subsequence containing only the last _n_ elements, where `amountToKeep` is _n_
    ///
    /// - Parameter amountToKeep: The amount of elements at the end to keep. If this is larger than the number of
    ///                           elements in this collection, then the subsequence contains all the elements.
    /// - Returns: A subsequence only containing the first _n_ elements
    @inlinable
    func onlyLast(_ amountToKeep: UInt) -> SubSequence {
        dropFirst(Swift.max(0, count - Int(amountToKeep)))
    }
}
