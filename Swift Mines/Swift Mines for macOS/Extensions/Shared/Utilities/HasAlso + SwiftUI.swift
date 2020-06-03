//
//  HasAlso + SwiftUI.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-11.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import SwiftUI



public extension View {
    func also(do additionalAction: () -> Void) -> Self {
        additionalAction()
        return self
    }
}
