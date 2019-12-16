//
//  MutableCollection Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-13.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension MutableCollection {
    
    /// Allows you to iterate over each element in this collection and mutate them one at a time
    ///
    /// - Parameter mutator: Mutates each element
    mutating func mutateEach(using mutator: (_ element: inout Element) throws -> Void) rethrows {
        for index in indices {
            try mutator(&self[index])
        }
    }
}
