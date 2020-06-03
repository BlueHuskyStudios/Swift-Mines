//
//  NumberPicker.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import SwiftUI



/// A SwiftUI number picker, like this:
///
/// ```
/// ┌────────────────┐ ▲
/// │ 10             │
/// └────────────────┘ ▼
///       Height
/// ```
///
/// ```
/// ┌────────────────┐ ▲
/// │ 42             │
/// └────────────────┘ ▼
/// ```
///
/// but prettier
public struct NumberPicker<N>: View
    where N: Strideable
{
    /// The label to display beneath the number picker. Set this to `nil` to hide the label.
    @State
    public var label: LocalizedStringKey? = nil
    
    /// The value to display and manipulate in the picker.
    ///
    /// This doesn't strictly have to be a number, just anything `Strideable`.
    public let value: Binding<N>
    
    /// Defines how to format the number in the text field
    private let formatter: NumberFormatter
    
    /// Defines the range of numbers allowed by the field and spinner
    private let range: ClosedRange<N>
    
    /// Whether to show the custom labels beneath the number picker.
    ///
    /// If `label` is `nil`, this has no effect. If `label` is set to some value, then this determines whether the
    /// custom text label appears beneath the number picker.
    ///
    /// Depending on the platform, a value of `true` might result in double labels.
    private var useCustomLabels = true
    
    
    public var body: some View {
        HStack(alignment: VerticalAlignment.top) {
            VStack(spacing: 2) {
                TextField(label ?? "", value: value, formatter: formatter)
                
                if useCustomLabels
                    && nil != label
                {
                    Text(label!)
                        .controlSize(.mini)
                        .foregroundColor(.secondary)
                }
            }
            
            Stepper(label ?? "", value: value, in: range)
                .labelsHidden()
        }
    }
}



public extension NumberPicker where N: BinaryInteger {
    
    /// Creates a new number picker
    ///
    /// - Parameters:
    ///   - label: _optional_ - The text to display beneath the number picker. Set this to `nil` to completely remove
    ///            the label. Defaults to `nil`.
    ///   - value: The value to show and manipulate with the number picker
    ///   - range: The valid range of values
    init(_ label: LocalizedStringKey? = nil, value: Binding<N>, range: ClosedRange<N>) {
        self.init(
            label: label,
            value: value,
            formatter: NumberFormatter.default.range(range),
            range: range
        )
    }
    
    
    /// Returns a copy of this view which might use custom labels based on the given value. The default is `true`.
    ///
    /// If `label` is `nil`, this has no effect. If `label` is set to some value, then this determines whether the
    /// custom text label appears beneath the number picker.
    ///
    /// Depending on the platform, a value of `true` might result in double labels.
    ///
    /// - Parameter useCustomLabels: Whether to display the custom labels
    func usingCustomLabels(_ useCustomLabels: Bool) -> Self {
        var copy = self
        copy.useCustomLabels = useCustomLabels
        return copy
    }
}



private extension NumberFormatter {
    /// The default number formatter for a number picker: Doesn't allow floats, with a minimul of `0` and no max.
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
        Group {
            NumberPicker("Height", value: .constant(10), range: 2...100)
                .previewLayout(.fixed(width: 100, height: 999))
            
            NumberPicker("Height", value: .constant(10), range: 2...100)
                .usingCustomLabels(false)
                .previewLayout(.fixed(width: 100, height: 999))
            
            NumberPicker(value: .constant(10), range: 2...100)
                .previewLayout(.fixed(width: 100, height: 999))
        }
    }
}
