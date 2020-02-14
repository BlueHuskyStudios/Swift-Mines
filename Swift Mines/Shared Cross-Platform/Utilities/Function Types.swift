//
//  Function Types.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-19.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Foundation



/// A function which can convert some arbitrary value into a boolean.
///
/// This is generally used to process sequences of data one item at a time, like `.filter`.
///
/// - Parameter element: The value to be evaluated
/// - Returns: A Boolean result of an evaluation
public typealias Predicate<Element> = (_ element: Element) -> Bool
