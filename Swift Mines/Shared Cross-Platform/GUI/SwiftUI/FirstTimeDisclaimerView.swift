//
//  FirstTimeDisclaimerView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-04.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI

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
                This was written entirely in Swift, using the new SwiftUI platform! Since SwiftUI is in its early stages, it has a few odd quirks. One that you'll notice is that it does not yet support right-clicking. For now, you can hold Control and click, or perform a long-click, to place a flag. Once SwiftUI supports right-clicking, this game will be update to include that.

                If you notice any other bugs, feel free to report them by selecting the "Feedback" item in the Help menu.

                Have fun!
                """)

            HStack {
                Spacer()
                Toggle("Never show this again", isOn: Binding(
                    get: { !self.overallAppState.oobeState.shouldShowDisclaimer },
                    set: { self.overallAppState.oobeState.shouldShowDisclaimer = !$0 })
                )
                NativeButton("Play without right-click", keyEquivalent: .return) { self.overallAppState.currentScreen = .game }
            }
        }
            .frame(minWidth: 480, idealWidth: 480, maxWidth: 480)
            .fixedSize()
            .padding()
    }
}

struct FirstTimeDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeDisclaimerView()
            .environmentObject(OverallAppState(game: Game(board: Board.empty(size: .zero).annotated(baseStyle: .default), playState: .notStarted)))
    }
}
