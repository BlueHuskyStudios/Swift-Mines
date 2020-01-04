//
//  UnicodeScalar Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-27.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



extension UnicodeScalar: Strideable {
    
    public typealias Stride = Int32
    
    
    
    public func distance(to other: UnicodeScalar) -> Stride {
        return Stride(self.value.distance(to: other.value))
    }
    
    public func advanced(by stride: Stride) -> UnicodeScalar {
        return UnicodeScalar(self.value.advanced(by: Stride.Stride(stride)))!
    }
}
