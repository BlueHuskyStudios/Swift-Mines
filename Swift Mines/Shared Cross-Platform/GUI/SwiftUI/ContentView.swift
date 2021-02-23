//
//  ContentView.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import SwiftUI
import RectangleTools
import SafePointer



/// The content view for a Swift Mines game.
///
/// Controls both the game and the new game setup screen.
public struct ContentView: View {
    
    /// The overall app state, which will be reflected and mutated by this view
    @Binding
    var overallAppState: OverallAppState
    
    
    public var body: some View {
        VStack(spacing: 0) {
            GameStatusBarView(onNewGameButtonPressed: {
                    self.overallAppState.game.startNewGame()
                })
                .frame(height: 48, alignment: .top)
            
            Spacer(minLength: 0)
            
            BoardView()
                .onSquareTapped { (square, action) in
                    print("Square tapped -", action)
                    self.overallAppState.game.updateBoard(after: action, at: square.cachedLocation)
                }
                .environment(\.overallAppState, overallAppState)
                .aspectRatio(CGSize(overallAppState.game.board.size), contentMode: .fit)
//                .also { print("ContentView Did regenerate view") }
            
            Spacer(minLength: 0)
        }
        .frame(minWidth: 160, idealWidth: 480, minHeight: 150, idealHeight: 300, alignment: .center)
        .disabled(self.overallAppState.currentScreen == .newGameSetup)
        .sheet(
            isPresented: $overallAppState.currentScreen.shouldShowSheet,
            content: {
                if overallAppState.currentScreen == .newGameSetup {
                    NewGameSetupView(overallAppState: $overallAppState)
                }
                else if overallAppState.currentScreen == .oobe {
                    FirstTimeDisclaimerView(overallAppState: $overallAppState)
                }
                else {
                    Text("This sheet should never be shown")
                    Button("OK") { overallAppState.currentScreen.shouldShowSheet = false }
                }
            })
    }
}



private extension AppScreen {
    var shouldShowSheet: Bool {
        get { [.newGameSetup, .oobe].contains(self) }
        set (isPresented) {
            if !isPresented {
                self = .game
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(overallAppState: .constant(.init(game: .new(size: Board.Size(width: 10, height: 10)))))
    }
}
