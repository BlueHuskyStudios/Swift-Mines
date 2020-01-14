//
//  SafePointer Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-04.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SafePointer



prefix operator *
postfix operator *



postfix func * <T, PointerToT> (rhs: T) -> PointerToT
    where
        PointerToT: Pointer,
        PointerToT.Pointee == T
{
    return PointerToT.init(to: rhs)
}


prefix func * <T, PointerToT> (rhs: PointerToT) -> T
    where
        PointerToT: Pointer,
        PointerToT.Pointee == T
{
    return rhs.pointee
}
