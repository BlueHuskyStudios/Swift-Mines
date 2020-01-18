//
//  FixedWidthInteger Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-19.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//



public extension FixedWidthInteger {
    
    static func +~ (lhs: Self, rhs: Self) -> Self {
        let result = lhs.addingReportingOverflow(rhs)
        if result.overflow {
            if rhs.signum() < 0 { // tried to subtract and got overflow
                return .min
            }
            else { // tried to add and got overflow
                return .max
            }
        }
        else {
            return result.partialValue
        }
    }
    
    
    static func -~ (lhs: Self, rhs: Self) -> Self {
        let result = lhs.subtractingReportingOverflow(rhs)
        if result.overflow {
            if rhs.signum() < 0 { // tried to add and got overflow
                return .max
            }
            else { // tried to subtract and got overflow
                return .min
            }
        }
        else {
            return result.partialValue
        }
    }
}



infix operator +~ : AdditionPrecedence
infix operator -~ : AdditionPrecedence
