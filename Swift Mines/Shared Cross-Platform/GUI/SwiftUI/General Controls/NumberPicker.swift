//
//  NumberPicker.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import SwiftUI



public struct NumberPicker<N>: View
    where N: Numeric,
        N: Comparable
{
    
    @State
    public var label: String = ""
    
    public let value: Binding<N>
    
    public private(set) var formatter = NumberFormatter.default
    
    
    public var body: some View {
        VStack(spacing: 2) {
            TextField(label, value: value, formatter: formatter)
            if !label.isEmpty {
                Text(label)
                    .controlSize(.mini)
                    .foregroundColor(.secondary)
            }
        }
    }
}



public extension NumberPicker where N: BinaryInteger {
    init(label: String = "", value: Binding<N>, range: ClosedRange<N>) {
        self.init(
            label: label,
            value: value,
            formatter: NumberFormatter.default.range(range)
        )
    }
}



private extension NumberFormatter {
    static let `default`: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.allowsFloats = false
        formatter.minimum = 0
        formatter.maximum = nil
        
        return formatter
    }()
}



struct NumberPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        NumberPicker(value: .constant(10), range: 2...100)
            .previewLayout(.fixed(width: 100, height: 999))
    }
}
