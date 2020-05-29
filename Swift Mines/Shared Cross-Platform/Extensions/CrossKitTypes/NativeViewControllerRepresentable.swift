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

public typealias AnyNativeViewControllerRepresentable = NSViewControllerRepresentable



public extension NativeViewControllerRepresentable {
    
    func makeNSViewController(context: Context) -> ViewControllerType {
        makeViewController(context: context)
    }
    
    
    func updateNSViewController(_ view: ViewControllerType, context: Context) {
        updateViewController(view, context: context)
    }
}

#elseif os(iOS)

public typealias AnyNativeViewControllerRepresentable = UIViewControllerRepresentable



public extension NativeViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ViewControllerType {
        makeViewController(context: context)
    }
    
    
    func updateUIControllerView(_ view: ViewControllerType, context: Context) {
        updateViewController(view, context: context)
    }
}

#endif



public protocol NativeViewControllerRepresentable: AnyNativeViewControllerRepresentable {
    
    associatedtype ViewControllerType: NativeViewController
    
    
    
    func makeViewController(context: Context) -> ViewControllerType
    
    
    func updateViewController(_ view: ViewControllerType, context: Context)
}
