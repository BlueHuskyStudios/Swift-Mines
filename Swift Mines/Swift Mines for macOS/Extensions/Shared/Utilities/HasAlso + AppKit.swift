//
//  HasAlso + AppKit.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-15.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import AppKit



public extension NSView {
    func alsoForView(do additionalAction: () -> Void) -> Self {
        additionalAction()
        return self
    }
}
