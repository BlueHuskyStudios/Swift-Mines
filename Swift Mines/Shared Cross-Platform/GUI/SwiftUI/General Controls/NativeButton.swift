//
//  NativeButton.swift
//
//  From this answer:
//  https://stackoverflow.com/a/58337529/3939277
//
//  Created by Sindre Sorhus on 2019-10-19.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#error("TODO: UIKit Support")
#elseif canImport(AppKit)
import AppKit
#else
#error("This file requires UIKit or AppKit")
#endif



// MARK: - Action closure for controls

private var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

protocol ControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

private final class ActionTrampoline<T>: NSObject {
    let action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc
    func action(sender: AnyObject) {
        action(sender as! T)
    }
}



extension ControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}



extension NSControl: ControlActionClosureProtocol {}



// MARK: -

/// A workaround for SwiftUI not supporting a default button
///
/// From this answer:
/// https://stackoverflow.com/a/58337529/3939277
@available(macOS 10.15, *)
struct NativeButton: NSViewRepresentable {
    enum KeyEquivalent: String {
        case escape = "\u{1b}"
        case `return` = "\r"
    }

    var title: String?
    var attributedTitle: NSAttributedString?
    var keyEquivalent: KeyEquivalent?
    let action: () -> Void

    init(
        _ title: String,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    init(
        _ attributedTitle: NSAttributedString,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.attributedTitle = attributedTitle
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }

    func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Self>) {
        if attributedTitle == nil {
            nsView.title = title ?? ""
        }

        if title == nil {
            nsView.attributedTitle = attributedTitle ?? NSAttributedString(string: "")
        }

        nsView.keyEquivalent = keyEquivalent?.rawValue ?? ""

        nsView.onAction { _ in
            self.action()
        }
    }
}
