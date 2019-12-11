//
//  RandomAccessCollection Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-10.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import RectangleTools



public extension RandomAccessCollection where Index: SignedInteger {
    subscript(_ index: UInt) -> Element {
        get {
            return self[.init(index)]
        }
    }
}



public extension RandomAccessCollection
    where
        Self: MutableCollection,
        Index: SignedInteger
{
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
    subscript(_ indices: BinaryIntegerPoint<Index>) -> Element.Element {
        return self[indices.y][indices.x]
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
    subscript(_ indices: UIntPoint) -> Element.Element {
        return self[indices.y][indices.x]
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
    subscript(_ indices: UIntPoint) -> Element.Element {
        get {
            return self[indices.y][indices.x]
        }
        set {
            self[indices.y][indices.x] = newValue
        }
    }
}
