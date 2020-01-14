//
//  HasAlso + SwiftUI.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-11.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension View {
    func also(do additionalAction: () -> Void) -> Self {
        additionalAction()
        return self
    }
}



//extension VStack: HasAlso {}
//extension HStack: HasAlso {}
//extension ForEach: HasAlso {}
//extension GeometryReader: HasAlso {}
//
//extension ModifiedContent: HasAlso {}
//extension _FlexFrameLayout: HasAlso {}
//extension _AspectRatioLayout: HasAlso {}
//extension _BackgroundModifier: HasAlso {}
//
//extension Image: HasAlso {}
//extension Color: HasAlso {}
