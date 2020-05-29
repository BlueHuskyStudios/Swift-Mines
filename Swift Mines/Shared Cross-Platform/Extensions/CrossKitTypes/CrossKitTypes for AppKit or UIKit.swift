//
//  NativeViewController.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2020-05-28.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

#if os(macOS)

import AppKit

public typealias NativeView = NSView
public typealias NativeViewController = NSViewController
public typealias NativeControl = NSControl
public typealias NativeButton = NSButton



public extension SystemButton {
}

#elseif os(iOS)

import UIKit

public typealias NativeView = UIView
public typealias NativeViewController = UIViewController
public typealias NativeControl = UIControl
public typealias NativeButton = UIButton



public extension NativeButton {
    var attributedTitle: NSAttributedString? {
        get { attributedTitle(for: .normal) }
        set { setAttributedTitle(newValue, for: .normal) }
    }
    
    
    var title: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
}

#endif
