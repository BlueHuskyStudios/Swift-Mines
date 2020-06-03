//
//  RangeReplaceableCollection Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-16.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation
import RectangleTools



public extension RangeReplaceableCollection
    where
        Self: MutableCollection,
        Index: BinaryInteger,
        Index.Stride: SignedInteger,
        Element: RangeReplaceableCollection,
        Element: MutableCollection,
        Element.Index == Self.Index
{
    /// Adjusts the size of this 2D collection so that it is exactly equal to the given size
    ///
    /// - Parameters:
    ///   - newSize:             The ideal new size of the collection after this function completes
    ///   - newElementGenerator: The function which will generate any new elements as needed (for instance, when
    ///                          expanding to a bigger size, or when adjusting an uneven 2D collection so that some
    ///                          rows expand).
    ///
    /// - Throws: Any error which occurs while generating a new element
    mutating func adjustSize(to newSize: UIntSize, newElementGenerator: NewElementGenerator2D) rethrows { // TODO: Test
        
        // Step 1: Adjust the existing rows
        try self.mutateEachIndexed { row, rowIndex in
            let rowIndexUint = UInt(rowIndex)
            try row.adjustCount(to: newSize.width, newElementGenerator: { columnIndex in
                try newElementGenerator(UIntPoint(x: UInt(columnIndex), y: rowIndexUint))
            })
        }
        
        // Step 2: Add new rows if needed
        try self.adjustCount(to: newSize.height, newElementGenerator: { rowIndex in
            let rowIndexUint = UInt(rowIndex)
            return try Element.init((0..<newSize.width).map { columnIndex in
                try newElementGenerator(UIntPoint(x: UInt(columnIndex), y: rowIndexUint))
            })
        })
    }
    
    
    
    /// Generates a new element when expanding an existing 2D collection
    ///
    /// - Parameter location: The location of the element to generate. This treats the 2D array as a 1D array of rows,
    ///                       each containing elements. Therefore, `y` is the row index (outer collection), and `x` is
    ///                       the column index (inner collection).
    ///
    /// - Returns: The new element to be placed into the new collection
    ///
    /// - Throws: Any error which occurs while generating the element
    typealias NewElementGenerator2D = (_ location: UIntPoint) throws -> Element.Element
}



public extension RangeReplaceableCollection
    where
        Self: MutableCollection,
        Index: BinaryInteger,
        Index.Stride: SignedInteger
{
    /// Adjusts the count of this collection so that it is exactly equal to the given count
    ///
    /// - Parameters:
    ///   - newCount:            The ideal new count of the collection after this function completes
    ///   - newElementGenerator: The function which will generate any new elements as needed (when
    ///                          expanding to a bigger count)
    ///
    /// - Throws: Any error which occurs while generating a new element
    mutating func adjustCount(to newCount: UInt, newElementGenerator: NewElementGenerator) rethrows { // TODO: Test
        guard newCount != count else {
            return
        }
        
        if newCount > count {
            let difference = Int(newCount) - count
            let newIndices = (endIndex ..< self.index(endIndex, offsetBy: difference))
            self.append(contentsOf: try newIndices.map(newElementGenerator))
        }
        else { // newCount < count
            self = Self.init(self[..<Index.init(newCount)])
        }
    }
    
    
    /// Generates a new element when expanding an existing collection
    ///
    /// - Parameter index: The index of the element to generate
    /// - Returns: The new element to be placed into the new collection
    /// - Throws: Any error which occurs while generating the element
    typealias NewElementGenerator = (_ index: Index) throws -> Element
}
