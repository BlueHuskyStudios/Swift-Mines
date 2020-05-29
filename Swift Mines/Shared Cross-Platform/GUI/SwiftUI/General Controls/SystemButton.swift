//
//  SystemButton.swift
//
//  From this answer:
//  https://stackoverflow.com/a/58337529/3939277
//
//  Created by Sindre Sorhus on 2019-10-19.
//  Modified by Ben Leggiero on 2020-01-26.
//  Copyright BH-0-PD: https://github.com/BlueHuskyStudios/Licenses/blob/master/Licenses/BH-0-PD.txt
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else
#error("This file requires UIKit or AppKit")
#endif



// MARK: - Action closure for controls

/// The key for the association when associating a native button to its action trampoline.
private var controlActionClosureProtocolAssociatedObjectKey = UInt8()



/// Formalizes an informal Cocoa pattern where a user action can be responded to by specifying some target object and
/// its method which will be called upon that user's action
protocol ControlActionClosureProtocol: NSObjectProtocol {
    
    func setTarget(_ target: AnyObject, forAction action: Selector)
}



/// "Bounces" a Cocoa action to any arbitrary function
private final class ActionTrampoline<T>: NSObject {
    
    /// The function which will receive the Cocoa action
    let action: (T) -> Void
    
    
    /// Creates a new action trampoline
    /// - Parameter action: The function which will receive the Cocoa action
    init(action: @escaping (T) -> Void) {
        self.action = action
    }
    
    
    /// Provides a selector to forward a Cocoa action to anything else
    ///
    /// - Attention: `sender` _**must**_ be of type `T`, or this function will crash immediately
    ///
    /// - Parameter sender: The object which sent the action
    @objc
    func action(sender: AnyObject) {
        action(sender as! T)
    }
}



extension ControlActionClosureProtocol {
    /// Attaches the given function to this object, allowing it to receive Cocoa events such as clicking, tapping,
    /// pressing the keyboard's "return" key, etc.
    ///
    /// - Parameter action: The function to be called when the action is performed
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.setTarget(trampoline, forAction: #selector(ActionTrampoline<Self>.action(sender:)))
        objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}



extension NativeControl: ControlActionClosureProtocol {
    func setTarget(_ target: AnyObject, forAction action: Selector) {
        #if os(macOS)
        // TODO
        #elseif os(iOS)
        
        self.addTarget(target, action: action, for: [.touchUpInside, .valueChanged, .editingChanged])
        
        #endif
    }
}



// MARK: -

/// A workaround for SwiftUI not supporting a button with native capabilities, such as being a form's default button,
/// receiving "return" and "excape" events, etc.
///
/// Slightly modified from the code in this StackOverflow answer:
/// https://stackoverflow.com/a/58337529/3939277
@available(macOS 10.15, *)
public struct SystemButton: NativeViewRepresentable {
    
    public typealias ViewType = NativeButton
    
    
    
    /// The text to show on the button
    private let title: String?
    
    /// The fancy text to show on the button
    private let attributedTitle: NSAttributedString?
    
    /// The key which might activate the button
    private let keyEquivalent: KeyEquivalent?
    
    /// The action to perform when the button is activated
    private let action: () -> Void
    
    
    /// Creates a new native button with the given properties
    ///
    /// - Parameters:
    ///   - title:         The text to show on the button
    ///   - keyEquivalent: _optional_ - The key which will activate the button. Defaults to no specific key.
    ///   - action:        The function which will respond to the button being pressed
    public init(
        _ title: String,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.attributedTitle = nil
        self.keyEquivalent = keyEquivalent
        self.action = action
    }
    
    
    /// Creates a new native button with the given properties
    /// - Parameters:
    ///   - attributedTitle: The fancy text to show on the button
    ///   - keyEquivalent:   _optional_ - The key which will activate the button. Defaults to no specific key.
    ///   - action:          The function which will respond to the button being pressed
    public init(
        _ attributedTitle: NSAttributedString,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.title = nil
        self.attributedTitle = attributedTitle
        self.keyEquivalent = keyEquivalent
        self.action = action
    }
    
    
    public func makeView(context: Context) -> ViewType {
        let button = ViewType()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }
    
    
    public func updateView(_ view: ViewType, context: Context) {
        if let attributedTitle = attributedTitle {
            view.attributedTitle = attributedTitle
        }
        else {
            view.title = title ?? "".also { assertionFailure("All buttons should have titles") }
        }
        
        #if os(macOS)
        if let keyEquivalent = keyEquivalent?.rawValue {
            view.keyEquivalent = keyEquivalent
        }
        #endif
        
        view.onAction { _ in
            self.action()
        }
    }
}



public extension SystemButton {
    
    /// Represents a key which can be pressed to activate a native button
    enum KeyEquivalent: String {
        
        /// ⎋ - The escape key
        case escape = "\u{1b}"
        
        /// ↩︎ - The return key
        case `return` = "\r"
    }
}
