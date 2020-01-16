//
//  SwiftUI + Hidden.swift
//  Swift Mines for macOS
//
//  Originally posted on StackOverflow:
//  https://stackoverflow.com/a/59228385/3939277
//
//  Created by George_E on 2019-12-07.
//  Placed in this project by Ben Leggiero on 2020-01-11.
//

import SwiftUI



extension View {
    
    /// Whether the view is hidden.
    /// - Parameter bool: Set to `true` to hide the view. Set to `false` to show the view.
    func isHidden(_ bool: Bool) -> some View {
        modifier(HiddenModifier(isHidden: bool))
    }
}



/// Creates a view modifier that can be applied, like so:
///
/// ```
/// Text("Hello World!")
///     .isHidden(true)
/// ```
///
/// Variables can be used in place so that the content can be changed dynamically.
private struct HiddenModifier: ViewModifier {
    
    fileprivate let isHidden: Bool
    
    
    fileprivate func body(content: Content) -> some View {
        Group {
            if isHidden {
                content.hidden()
            }
            else {
                content
            }
        }
    }
}
