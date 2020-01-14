//
//  forSwiftUi.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-15.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

#if canImport(Cocoa)
import Cocoa
#elseif canImport(CocoaTouch)
#error("TODO: CocoaTouch support")
#endif



public extension NSView {
    func forSwiftUi() -> some NSViewRepresentable {
        NSViewRepresentedInSwiftUi(view: self)
    }
}



public struct NSViewRepresentedInSwiftUi: NSViewRepresentable {
    
    public typealias NSViewType = NSView
    
    let view: NSView
    
    
    public func makeNSView(context: Context) -> NSView {
        return view
    }
    
    
    public func updateNSView(_ nsView: NSView, context: Context) {
        nsView.needsDisplay = true
    }
}
