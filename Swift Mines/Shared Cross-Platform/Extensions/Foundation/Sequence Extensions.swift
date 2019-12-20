//
//  Sequence Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-15.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension Sequence {
    
    /// Returns a lazily-evaluated sequence where `nil` elements are skipped
    @inlinable
    func discardingNilElements<Wrapped>() -> OnlyNonNilElements<Wrapped> where Element == Wrapped? {
        self.lazy.compactMap { $0 }
    }
    
    
    
    typealias OnlyNonNilElements<Wrapped> = LazyMapSequence<LazyFilterSequence<LazyMapSequence<Self, Wrapped?>>, Wrapped>
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
    
    
    
    typealias Predicate = (Element) -> Bool
    
    typealias OnlyCertainElements = LazyFilterSequence<Self>
}
