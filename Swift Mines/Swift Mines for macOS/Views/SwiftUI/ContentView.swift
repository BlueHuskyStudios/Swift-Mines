//
//  ContentView.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import RectangleTools



struct ContentView: View {
    
    @State
    var game: Game {
        didSet {
            print("ContentView did set game")
        }
    }
    
    
    var body: some View {
        BoardView(board: game.board)
            .onSquareTapped { (square, action) in
                print("Square tapped -", action)
                self.game = Game(id: UUID(),
                                 board: self.game.board.allRevealed(reason: .manuallyTriggered),
                                 playState: .playing)
                //self.game.updateBoard(after: action, at: square.cachedLocation)
            }
            .forSwiftUi()
            .also { print("ContentView Did regenerate view") }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: Game(id: UUID(), board: Board(content: UIntSize(width: 10, height: 10).map2D { _ in .random() }).annotated(baseStyle: .default), playState: .notStarted))
    }
}
