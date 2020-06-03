//
//  NativeImage + SwiftUI.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-18.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

#if canImport(SwiftUI)
import SwiftUI
import CrossKitTypes



public extension Image {
    init(native nativeImage: NativeImage) {
        #if !ONLY_APP_KIT && canImport(UIKit)
        self.init(uiImage: nativeImage)
        #elseif canImport(AppKit)
        self.init(nsImage: nativeImage)
        #else
        #error("UIKit or AppKit is required for this file")
        #endif
    }
}

#endif
