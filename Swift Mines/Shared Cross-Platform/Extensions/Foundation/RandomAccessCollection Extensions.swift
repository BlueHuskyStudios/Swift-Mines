//
//  RandomAccessCollection Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-10.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import RectangleTools
import SafeCollectionAccess



public extension RandomAccessCollection where Index: SignedInteger {
    
    @inlinable
    subscript(_ index: UInt) -> Element {
        return self[Index.init(index)]
    }
    
    
    @inlinable
    subscript(orNil index: UInt) -> Element? {
        return self[orNil: Index.init(index)]
    }
}



public extension RandomAccessCollection
    where
        Self: MutableCollection,
        Index: SignedInteger
{
    @inlinable
    subscript(_ index: UInt) -> Element {
        get {
            return self[.init(index)]
        }
        set {
            self[.init(index)] = newValue
        }
    }
}



public extension RandomAccessCollection
    where
        Index: BinaryInteger,
        Element: RandomAccessCollection,
        Element.Index == Self.Index
{
    /// Allows you to access this 2D collection's elements using a 2D coordinate, where `y` is the row (outer index)
    /// and `x` is the column (inner index).
    @inlinable
    subscript(_ indices: BinaryIntegerPoint<Index>) -> Element.Element {
        return self[indices.y][indices.x]
    }
    
    
    /// Allows you to safely access this 2D collection's elements using a 2D coordinate, where `y` is the row (outer
    /// index) and `x` is the column (inner index). If either of these indices is outside its respective collection,
    /// `nil` is returned.
    @inlinable
    subscript(orNil indices: BinaryIntegerPoint<Index>) -> Element.Element? {
        return self[orNil: indices.y]?[orNil: indices.x]
    }
    
    
    /// An alias to `size`
    @inline(__always)
    var count2d: UIntSize { size }
    
    
    /// The size of this 2D collection
    ///
    /// - Note: The returned `height` is always the same as `count`, but the returned `width` is the **maximum** of all
    ///         rows' `count`s. In other words, if this collection is not a perfect rectangle, this will return the
    ///         size of a rectangle that encompasses it.
    var size: UIntSize {
        if isEmpty {
            return .zero
        }
        else {
            return UIntSize(
                width: UInt(self.lazy.map { $0.count }.reduce(0, Swift.max)),
                height: UInt(count)
            )
        }
    }
}



public extension RandomAccessCollection
    where
        Self: MutableCollection,
        Index: BinaryInteger,
        Element: RandomAccessCollection,
        Element: MutableCollection,
        Element.Index == Self.Index
{
    @inlinable
    subscript(_ indices: BinaryIntegerPoint<Index>) -> Element.Element {
        get {
            return self[indices.y][indices.x]
        }
        set {
            self[indices.y][indices.x] = newValue
        }
    }
}



public extension RandomAccessCollection
    where
        Index: SignedInteger,
        Element: RandomAccessCollection,
        Element.Index == Self.Index
{
    @inlinable
    subscript(_ indices: UIntPoint) -> Element.Element {
        return self[indices.y][indices.x]
    }
    
    
    @inlinable
    subscript(orNil indices: UIntPoint) -> Element.Element? {
        return self[orNil: indices.y]?[orNil: indices.x]
    }
}



public extension RandomAccessCollection
    where
        Self: MutableCollection,
        Index: SignedInteger,
        Element: RandomAccessCollection,
        Element: MutableCollection,
        Element.Index == Self.Index
{
    @inlinable
    subscript(_ indices: UIntPoint) -> Element.Element {
        get {
            return self[indices.y][indices.x]
        }
        set {
            self[indices.y][indices.x] = newValue
        }
    }
}
