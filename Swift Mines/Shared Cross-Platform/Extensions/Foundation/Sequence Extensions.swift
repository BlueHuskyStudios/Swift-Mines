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
