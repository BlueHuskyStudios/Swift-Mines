//
//  Size2D Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import RectangleTools



public extension Size2D {
    var humanReadableDescription: String { "(\(width) × \(height))" }
}



/// Creates a size of the given width by the given height, such that `11 * 17` is the same as `.init(width: 11, height: 17)`
///
/// - Parameters:
///   - width:  The width of the new size
///   - height: The height of the new size
@inlinable
public func * <Length, Size> (width: Length, height: Length) -> Size
    where Size: Size2D,
        Size.Length == Length
{
    return Size.init(width: width, height: height)
}
