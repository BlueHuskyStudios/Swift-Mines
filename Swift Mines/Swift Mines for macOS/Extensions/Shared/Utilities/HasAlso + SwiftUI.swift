//
//  HasAlso + SwiftUI.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-11.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import SwiftUI



public extension View {
    func also(do additionalAction: () -> Void) -> Self {
        additionalAction()
        return self
    }
}
