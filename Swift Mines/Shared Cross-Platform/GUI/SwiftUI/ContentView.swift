//
//  ContentView.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import SwiftUI
import RectangleTools
import SafePointer



/// The content view for a Swift Mines game.
///
/// Controls both the game and the new game setup screen.
public struct ContentView: View {
    
    /// The overall app state, which will be reflected and mutated by this view
    @EnvironmentObject
    var overallAppState: OverallAppState
    
    
    public var body: some View {
        VStack(spacing: 0) {
            GameStatusBarView() {
                    self.overallAppState.game.startNewGame()
                }
                .frame(height: 48, alignment: .top)
            
            Spacer(minLength: 0)
            
            BoardView()
                .onSquareTapped { (square, action) in
                    print("Square tapped -", action)
                    self.overallAppState.game.updateBoard(after: action, at: square.cachedLocation)
                }
                .environmentObject(overallAppState)
                .aspectRatio(CGSize(overallAppState.game.board.size), contentMode: .fit)
                .also { print("ContentView Did regenerate view") }
            
            Spacer(minLength: 0)
        }
        .disabled(self.overallAppState.currentScreen == .newGameSetup)
        .sheet(
            isPresented: Binding(
                get: {
                    [.newGameSetup, .oobe].contains(self.overallAppState.currentScreen)
                },
                set: { isPresented in
                    if !isPresented {
                        self.overallAppState.currentScreen = .game
                    }
                }
            ),
            content: {
                Group {
                    if self.overallAppState.currentScreen == .newGameSetup {
                        NewGameSetupView().environmentObject(self.overallAppState)
                    }
                    else {
                        FirstTimeDisclaimerView().environmentObject(self.overallAppState)
                    }
                }
            })
    }
}



struct ContentView_Previews: PreviewProvider {
    
    @EnvironmentObject
    static var overallAppState: OverallAppState
    
    static var previews: some View {
        overallAppState.game = Game.new(size: Board.Size(width: 10, height: 10))
        
        return ContentView()
    }
}
