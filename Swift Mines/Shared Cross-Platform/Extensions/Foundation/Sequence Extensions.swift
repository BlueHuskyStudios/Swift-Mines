//
//  Sequence Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-15.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation



public extension Sequence {
    
    /// Returns a lazily-evaluated sequence where `nil` elements are skipped
    @inlinable
    func discardingNilElements<Wrapped>() -> OnlyNonNilElements<Wrapped> where Element == Wrapped? {
        self.lazy.compactMap { $0 }
    }
    
    
    
    /// The kind of sequence which is returned from a function which strips another sequence of its nil elements
    typealias OnlyNonNilElements<Wrapped> = LazyMapSequence<LazyFilterSequence<LazyMapSequence<Self, Wrapped?>>, Wrapped>
}



public extension Sequence where Element: AdditiveArithmetic, Element: ExpressibleByIntegerLiteral {
    
    /// Sums this sequence
    ///
    /// If this sequence is empty, `0` is returned.
    ///
    /// - Returns: The sum of all elements in this sequence
    @inlinable
    func summed() -> Element {
        return reduce(into: 0, +=)
    }
}



public extension Sequence {
    
    /// Returns a lazily-evaluated sequence where only elements which match the given predicate are kept
    /// - Parameter isIncluded: Decides whether a given element is included
    @inlinable
    func onlyIncluding(where isIncluded: @escaping Predicate) -> OnlyCertainElements {
        self.lazy.filter(isIncluded)
    }
    
    
    /// Returns a lazily-evaluated sequence where only elements which match the given predicate are discarded
    /// - Parameter isDiscarded: Decides whether a given element is discarded
    @inlinable
    func discarding(where isDiscarded: @escaping Predicate) -> OnlyCertainElements {
        onlyIncluding(where: !isDiscarded)
    }
    
    
    
    /// Evaluates an element and returns the Boolean result of that evaluation
    typealias Predicate = (Element) -> Bool
    
    /// The kind of sequence which contains only certain elements of another sequence
    typealias OnlyCertainElements = LazyFilterSequence<Self>
}
