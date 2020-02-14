//
//  FirstTimeDisclaimerView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-04.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import SwiftUI
import Combine



public struct FirstTimeDisclaimerView: View {
    
    /// This will be set to `.game` once the user is done reading the disclaimer
    @EnvironmentObject
    private var overallAppState: OverallAppState
    

    public var body: some View {
        Form {
            Text("Thanks for trying out this early version of Swift Mines!")
                .font(.title)

            Spacer()
                .fixedSize()

            Text("""
                This was written entirely in Swift, using the new SwiftUI platform! Since SwiftUI is in its early stages, it has a few odd quirks. One that you'll notice is that it does not yet support \(phrase_secondaryClicking). For now, you can hold Control and click, or perform a long-click, to place a flag. Once SwiftUI supports \(phrase_secondaryClicking), this game will be update to include that.

                If you notice any other bugs, feel free to report them by selecting the "Feedback" item in the Help menu.

                Have fun!
                """)

            HStack {
                Spacer()
                Toggle("Never show this again", isOn: Binding(
                    get: { !self.overallAppState.oobeState.shouldShowDisclaimer },
                    set: { self.overallAppState.oobeState.shouldShowDisclaimer = !$0 })
                )
                NativeButton("Play without \(phrase_secondaryClick)", keyEquivalent: .return) { self.overallAppState.currentScreen = .game }
            }
        }
            // TODO: something like .onReceive(UserDefaults.standard.publisher(for: \UserDefaults.swapRightLeftMouseButton), perform: { print($0) })
            .frame(minWidth: 480, idealWidth: 480, maxWidth: 480)
            .fixedSize()
            .padding()
    }
}



private extension FirstTimeDisclaimerView {
    /// The phrase to use to represent "secondary-clicking", keeping in mind the user's current handedness preference
    var phrase_secondaryClicking: StringLiteralType /* TODO: LocalizedStringKey */ {
        switch UserDefaults.standard.mouseHandedness {
        case .leftHanded:
            return "left-clicking"
            
        case .rightHanded:
            return "right-clicking"
        }
    }
    
    
    /// The phrase to use to represent "secondary-click", keeping in mind the user's current handedness preference
    var phrase_secondaryClick: StringLiteralType /* TODO: LocalizedStringKey */ {
        switch UserDefaults.standard.mouseHandedness {
        case .leftHanded:
            return "left-click"
            
        case .rightHanded:
            return "right-click"
        }
    }
}



struct FirstTimeDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeDisclaimerView()
            .environmentObject(OverallAppState(game: Game(board: Board.empty(size: .zero).annotated(baseStyle: .default), playState: .notStarted)))
    }
}
