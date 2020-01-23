//
//  HasAlso.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-11.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import Foundation



public protocol HasAlso {
    /// Returns this value after performing the given action
    ///
    /// - Parameter additionalAction: The action to perform before returning this value
    /// - Returns: This value, unchanged
    func also(do additionalAction: () -> Void) -> Self
}



public extension HasAlso {
    func also(do additionalAction: () -> Void) -> Self {
        additionalAction()
        return self
    }
}



// MARK: - Default conformances

extension NSObject: HasAlso {}



extension Int: HasAlso {}
extension Int8: HasAlso {}
extension Int16: HasAlso {}
extension Int32: HasAlso {}
extension Int64: HasAlso {}

extension UInt: HasAlso {}
extension UInt8: HasAlso {}
extension UInt16: HasAlso {}
extension UInt32: HasAlso {}
extension UInt64: HasAlso {}

extension CGFloat: HasAlso {}
extension Float32: HasAlso {}
extension Float64: HasAlso {}



extension String: HasAlso {}
extension Array: HasAlso {}
extension Dictionary: HasAlso {}
extension Set: HasAlso {}

//extension Never: HasAlso {}
