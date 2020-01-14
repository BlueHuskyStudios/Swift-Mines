//
//  HasTransform.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-13.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// An object which has a transform method
public protocol HasTransform {
    
    /// Transforms this value into a new one
    ///
    /// - Parameter transformer: Performs the transformation
    func transform<New>(with transformer: (_ old: Self) throws -> New) rethrows -> New
}



public extension HasTransform {
    
    func transform<New>(with transformer: (_ old: Self) throws -> New) rethrows -> New {
        return try transformer(self)
    }
}



// MARK: - Default conformances

extension NSObjectProtocol {
    
    public func transform<New>(with transformer: (_ old: Self) throws -> New) rethrows -> New {
        return try transformer(self)
    }
}



extension Int: HasTransform {}
extension Int8: HasTransform {}
extension Int16: HasTransform {}
extension Int32: HasTransform {}
extension Int64: HasTransform {}

extension UInt: HasTransform {}
extension UInt8: HasTransform {}
extension UInt16: HasTransform {}
extension UInt32: HasTransform {}
extension UInt64: HasTransform {}

extension CGFloat: HasTransform {}
extension Float32: HasTransform {}
extension Float64: HasTransform {}



extension String: HasTransform {}
extension Array: HasTransform {}
extension Dictionary: HasTransform {}
extension Set: HasTransform {}