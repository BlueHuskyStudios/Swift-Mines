//
//  NumberPicker.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI



public struct NumberPicker<N: Numeric>: View {
    
    @State
    public var label: String = ""
    
    public var value: Binding<N>
    
    public var body: some View {
        VStack(spacing: 2) {
            TextField(label, value: value, formatter: NumberFormatter())
            if !label.isEmpty {
                Text(label)
                    .controlSize(.mini)
                    .foregroundColor(.secondary)
            }
        }
    }
}



struct NumberPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        NumberPicker(value: .constant(10))
            .previewLayout(.fixed(width: 100, height: 999))
    }
}
