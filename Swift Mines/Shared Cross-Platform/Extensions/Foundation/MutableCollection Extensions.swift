//
//  MutableCollection Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-13.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation



public extension MutableCollection {
    
    /// Allows you to iterate over each element in this collection and mutate them one at a time
    ///
    /// - Parameter mutator: Mutates each element
    ///
    /// - Throws: Any error that `mutator` throws
    @inlinable
    mutating func mutateEach(using mutator: Mutator) rethrows {
        try mutateEachIndexed { element, _ in
            try mutator(&element)
        }
    }
    
    
    /// Allows you to iterate over each element in this collection and mutate them one at a time
    ///
    /// - Parameter mutator: Mutates each element
    ///
    /// - Throws: Any error that `mutator` throws
    @inlinable
    mutating func mutateEachIndexed(using mutator: IndexedMutator) rethrows {
        for index in indices {
            try mutator(&self[index], index)
        }
    }
    
    
    
    /// A function which will mutate an element
    /// - Parameter element: The element to be mutated
    /// - Throws: Any error that occurs while mutating the element
    typealias Mutator = (_ element: inout Element) throws -> Void
    
    /// A function which will mutate an element, additionally passing its index in case you need to know it
    ///
    /// - Parameters:
    ///   - element: The element to be mutated
    ///   - index:   The index of `element` in this collection
    ///
    /// - Throws: Any error that occurs while mutating the element
    typealias IndexedMutator = (_ element: inout Element, _ index: Index) throws -> Void
}
