//
//  ContentView.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import RectangleTools
import SafePointer



struct ContentView: View {
    
    @EnvironmentObject
    var overallAppState: OverallAppState
    
    
    var body: some View {
        VStack(spacing: 0) {
            GameStatusBarView() {
                    self.overallAppState.game.startNewGame()
                }
                .frame(height: 48, alignment: .top)
            
            BoardView()
                .onSquareTapped { (square, action) in
                    print("Square tapped -", action)
                    self.overallAppState.game.updateBoard(after: action, at: square.cachedLocation)
                }
//                .wrappedForSwiftUi()
                .environmentObject(overallAppState)
                .aspectRatio(1, contentMode: .fit)
                .also { print("ContentView Did regenerate view") }
        }
        .sheet(
            isPresented: Binding(
                get: { self.overallAppState.currentScreen == .newGameSetup },
                set: { shouldShowSetup in self.overallAppState.currentScreen = shouldShowSetup ? .newGameSetup : .game }
            ),
            onDismiss: { self.overallAppState.game.startNewGame() },
            content: { NewGameSetupView().environmentObject(self.overallAppState) })
        
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
