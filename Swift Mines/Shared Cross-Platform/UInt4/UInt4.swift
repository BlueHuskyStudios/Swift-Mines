
#error("TODO: This was started but never completed")



//
//  UInt4.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-25.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public struct UInt4 { // TODO: Test
    fileprivate var storage: Storage
    
    
    typealias Storage = UInt8
}



public extension FixedWidthInteger {
    typealias OverflowableOperation = (_ lhs: Self, _ rhs: Self) -> OverflowableResult
    typealias OverflowableResult = (partialValue: Self, overflow: Bool)
}



extension UInt4: BinaryInteger {
    public typealias Words = UInt8.Words
    
    public typealias Magnitude = Self
    
    public static func + (lhs: UInt4, rhs: UInt4) -> UInt4 {
        <#code#>
    }
    
    public static func -= (lhs: inout UInt4, rhs: UInt4) {
        <#code#>
    }
    
    public typealias IntegerLiteralType = Self
    
    
}



extension UInt4: FixedWidthInteger {
    public static var bitWidth: Int { 4 }
    
    fileprivate static let storageValueRange = Storage(0x0)...Storage(0xF)
    
    
    private func reportingOverflow(after operation: Storage.OverflowableOperation, on rhs: Self) -> OverflowableResult {
        let baseResult = operation(Storage(self), Storage(rhs))
        
        if Self.storageValueRange.contains(baseResult.partialValue),
            !baseResult.overflow {
            return (.init(baseResult.partialValue), false)
        }
        else {
            return (.init(baseResult.partialValue), true)
        }
    }
    
    
    public func addingReportingOverflow(_ rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        return reportingOverflow(after: storage.addingReportingOverflow, on: rhs)
        let baseResult = storage.addingReportingOverflow(rhs.storage)
        
        if Self.storageValueRange.contains(baseResult.partialValue),
            !baseResult.overflow {
            return (.init(baseResult.partialValue), false)
        }
        else {
            return (.init(baseResult.partialValue), true)
        }
    }
    
    public func subtractingReportingOverflow(_ rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        <#code#>
    }
    
    public func multipliedReportingOverflow(by rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        <#code#>
    }
    
    public func dividedReportingOverflow(by rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        <#code#>
    }
    
    public func remainderReportingOverflow(dividingBy rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        <#code#>
    }
    
    public func multipliedFullWidth(by other: UInt4) -> (high: UInt4, low: UInt4.Magnitude) {
        <#code#>
    }
    
    public func dividingFullWidth(_ dividend: (high: UInt4, low: UInt4.Magnitude)) -> (quotient: UInt4, remainder: UInt4) {
        <#code#>
    }
    
    public var nonzeroBitCount: Int {
        <#code#>
    }
    
    public var leadingZeroBitCount: Int {
        <#code#>
    }
    
    public var byteSwapped: UInt4 {
        <#code#>
    }
    
    
}



extension UInt4: UnsignedInteger {
    
}
