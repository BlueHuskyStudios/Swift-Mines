//
//  NativeViewRepresentable.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2020-05-27.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI
import CrossKitTypes



#if os(macOS)

public typealias AnyNativeViewRepresentable = NSViewRepresentable



public extension NativeViewRepresentable {
    
    func makeNSView(context: Context) -> ViewType {
        makeView(context: context)
    }
    
    
    func updateNSView(_ view: ViewType, context: Context) {
        updateView(view, context: context)
    }
}

#elseif os(iOS)

public typealias AnyNativeViewRepresentable = UIViewRepresentable



public extension NativeViewRepresentable {
    
    func makeUIView(context: Context) -> ViewType {
        makeView(context: context)
    }
    
    
    func updateUIView(_ view: ViewType, context: Context) {
        updateView(view, context: context)
    }
}

#endif



public protocol NativeViewRepresentable: AnyNativeViewRepresentable {
    
    associatedtype ViewType: NativeView
    
    
    
    func makeView(context: Context) -> ViewType
    
    
    func updateView(_ view: ViewType, context: Context)
}
