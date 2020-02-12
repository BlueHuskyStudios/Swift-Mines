//
//  ByLengthInitializableCollection.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-16.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation



/// A collection which can be initialized by providing a length and an element generator
public protocol ByLengthInitializableCollection: Collection {
    
    /// Initializes this collection to the given length. If this collection type does not support the given length, it
    /// may throw `CollectionLengthNotSupported`.
    ///
    /// - Parameters:
    ///   - length:           The number of elements in the resulting collection
    ///   - elementGenerator: Generates each new element
    ///
    /// - Throws: Anything `elementGenerator` throws, or `CollectionLengthNotSupported` if the given length is not in
    ///           this collection's supported range.
    init(length: UInt, elementGenerator: ElementGenerator) throws
    
    
    
    /// Generates a new element when creating a new collection
    ///
    /// - Parameter index: The index of the element to generate
    /// - Returns: The new element to be placed into the new collection
    /// - Throws: Any error which occurs while generating the element
    typealias ElementGenerator = (_ index: Index) throws -> Element
}



/// Thrown when a collection init is attempted using a length value which the collection does not support.
///
/// For instance, a non-empty collection might throw this when you try to initialize it with a length of `0`, or a
/// collection which is indexed by an 8-bit integer type might throw this when you pass `300`.
public struct CollectionLengthNotSupported {
    
    /// The invalid length that was passed to the initializer
    let requestedLength: UInt
    
    /// The range of values the initializer supports
    let supportedLengthRange: ClosedRange<UInt>
}



// MARK: - Default conformances

extension Array: ByLengthInitializableCollection {
    public init(length: UInt, elementGenerator: (Index) throws -> Element) throws {
        self = try (0..<length)
            .lazy
            .map(Index.init(_:))
            .map(elementGenerator)
    }
}
