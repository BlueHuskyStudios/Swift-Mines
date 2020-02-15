//
//  View Extensions.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-23.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import SwiftUI



public extension View {
    /// Positions the view within an invisible frame with the specified percentage of the parent's size.
    ///
    /// - Parameters:
    ///   - percentWidth:  A percent of a fixed width for the resulting view. If it's is `nil`, the resulting view assumes this view’s sizing behavior.
    ///   - percentHeight: A percent of a fixed height for the resulting view. If it's is `nil`, the resulting view assumes this view’s sizing behavior.
    ///   - alignment:     The alignment of this view inside the resulting view. alignment applies if this view is smaller than the size given by the resulting frame.
    ///   - geometry:      The geometry context in which the result should be calculated
    @inlinable
    func frame(percentWidth: CGFloat? = nil, percentHeight: CGFloat? = nil, alignment: Alignment = .center, in geometry: GeometryProxy) -> some View {
        self.frame(width: percentWidth.map { wp in geometry.size.width * wp },
                   height: percentHeight.map { hp in geometry.size.height * hp },
                   alignment: alignment)
    }
    
    
    /// Fixes the center of the view at the specified coordinates in its parent’s coordinate space.
    ///
    /// - Parameters:
    ///   - percentX: The percent along the x axis at which to place the center of this view.
    ///   - percentY: The percent along the y axis at which to place the center of this view.
    ///   - geometry: The geometry context in which the result should be calculated
    ///
    /// - Returns: A view that fixes the center of this view at the given percentages along the x and y axes.
    @inlinable
    func position(percentX: CGFloat, percentY: CGFloat, in geometry: GeometryProxy) -> some View {
        self.position(x: percentX * geometry.size.width,
                      y: percentY * geometry.size.height)
    }
}
