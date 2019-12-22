//
//  SevenSegmentDisplay.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-20.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct SevenSegmentDisplay: View {
    
    @State
    var color: Color
    
    @State
    var displayState: UInt8
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct SevenSegmentDisplay_Previews: PreviewProvider {
    static var previews: some View {
        SevenSegmentDisplay(color: .red, displayState: 0b10101010)
    }
}
