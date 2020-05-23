//
//  IndexPath Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-16.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation
import RectangleTools
import MultiplicativeArithmetic



public extension IndexPath {
    
    // TODO: Test
    /// Converts this index path into a point in the given size, scanline-style
    ///
    /// ```
    ///  y x→  0   1   2
    ///  ↓
    ///      ┌───┬───┬───┐
    ///  0   │ 0 │ 1 │ 2 │
    ///      ├───┼───┼───┤ = (3 × 2)
    ///  1   │ 3 │ 4 │ 5 │
    ///      └───┴───┴───┘
    /// ```
    ///
    /// - Parameters:
    ///   - size:               The overall size of the object which is using the `IndexPath`
    ///   - sectionRequirement: Your requirement for how the point is chosen
    func asPoint<I>(
        in size: BinaryIntegerSize<I>,
        sectionRequirement: AsPointSectionBehavior
    ) -> BinaryIntegerPoint<I>?
        where
            I: BinaryInteger,
            I: MultiplicativeArithmetic
    {
        typealias Point = BinaryIntegerPoint<I>
        
        
        
        let unrolledIndex = I.init(item)
        
        guard (0..<size.area).contains(unrolledIndex) else {
            return nil
        }
        
        
        /// Implements the behavior for when the user chooses `.onlyAllowOneParticularSection` as the
        /// `sectionRequirement`. See the documentation for `.onlyAllowOneParticularSection` for more.
        ///
        /// - Parameter allowedSectionIndex: The index which is the only one that is allowed
        func onlyAllowingOneParticularSection(allowedSectionIndex: Int) -> Point? {
            guard section == allowedSectionIndex else {
                return nil
            }
            
            return disregardSectionIndex()
        }
        
        
        /// Implements the behavior for when the user chooses `.disregardSectionIndex` as the
        /// `sectionRequirement`. See the documentation for `.disregardSectionIndex` for more.
        func disregardSectionIndex() -> Point? {
            Point(x: unrolledIndex % size.width,
                  y: unrolledIndex / size.height)
        }
        
        
//        func multiplyingUnrolledItemIndexBySectionNumber() -> Point? {
//            TODO("multiplyingUnrolledItemIndexBySectionNumber")
//        }
//
//
//        func multiplyingYIndexBySectionNumber() -> Point? {
//            TODO("multiplyingYIndexBySectionNumber")
//        }
        
        
        switch sectionRequirement {
        case .onlyAllowOneParticularSection(let allowedSectionIndex):
            return onlyAllowingOneParticularSection(allowedSectionIndex: allowedSectionIndex)
            
        case .disregardSectionIndex:
            return disregardSectionIndex()
            
//        case .multiplyUnrolledItemIndexBySectionNumber:
//            return multiplyingUnrolledItemIndexBySectionNumber()
//
//        case .multiplyYIndexBySectionNumber:
//            return multiplyingYIndexBySectionNumber()
        }
    }
    
    
    
    /// How to treat the section component of an index path when converting the path to a point
    enum AsPointSectionBehavior {
        
        /// Only one section is allowed. If this index path has any other section index, the operation will fail and
        /// `nil` will be returned.
        case onlyAllowOneParticularSection(allowedSectionIndex: Int)
        
        /// The section index will be ignored entirely
        case disregardSectionIndex
        
//        /// (The section index plus one) will be multiplied by the item index
//        case multiplyUnrolledItemIndexBySectionNumber
//
//        /// The section index will be ignored until return time, at which point the Y value will be multiplied by (the
//        /// section index plus one)
//        case multiplyYIndexBySectionNumber
    }
}



public extension IndexPath.AsPointSectionBehavior {
    
    /// An on-demand pre-computed alias for `onlyAllowOneParticularSection(allowedSectionIndex: 0)`
    static let onlyAllowSectionZero = onlyAllowOneParticularSection(allowedSectionIndex: 0)
}
