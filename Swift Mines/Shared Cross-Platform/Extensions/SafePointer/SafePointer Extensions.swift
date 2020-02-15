//
//  SafePointer Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-04.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import SafePointer



prefix operator *
postfix operator *



/// Wraps the given value in a pointer
///
/// ```
/// let value = 7
/// let pointer: SafePointer = value*
/// print(pointer.pointee) // 7
/// ```
///
/// - Parameter rhs: The value to be wrapped into a pointer
@inlinable
public postfix func * <T, PointerToT> (rhs: T) -> PointerToT
    where
        PointerToT: Pointer,
        PointerToT.Pointee == T
{
    return PointerToT.init(to: rhs)
}


/// Dereferences the given pointer, so that its pointee may be used directly.
///
/// ```
/// let value = 7
/// let pointer = SafePointer(value)
/// print(*pointer) // 7
/// ```
///
/// - Parameter rhs: The pointer to be dereferenced
@inlinable
public prefix func * <T, PointerToT> (rhs: PointerToT) -> T
    where
        PointerToT: Pointer,
        PointerToT.Pointee == T
{
    return rhs.pointee
}
