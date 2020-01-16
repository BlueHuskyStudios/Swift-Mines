//
//  Simple Functional Utilities.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Negates the results of given predicate
///
/// - Parameter predicate: The function whose result to negate
@inlinable
public prefix func ! <T> (_ predicate: @escaping Predicate<T>) -> Predicate<T> {{ element in
    !predicate(element)
}}
