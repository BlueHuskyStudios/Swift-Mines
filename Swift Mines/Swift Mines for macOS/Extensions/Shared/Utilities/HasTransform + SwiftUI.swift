//
//  HasTransform + SwiftUI.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-13.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension View {
    func transformForView<New>(with transformer: (_ old: Self) throws -> New) rethrows -> New {
        return try transformer(self)
    }
}



extension VStack: HasTransform {}
extension HStack: HasTransform {}
extension ForEach: HasTransform {}
extension GeometryReader: HasTransform {}

extension ModifiedContent: HasTransform {}
extension _FlexFrameLayout: HasTransform {}
extension _AspectRatioLayout: HasTransform {}
extension _BackgroundModifier: HasTransform {}

extension Image: HasTransform {}
extension Color: HasTransform {}
