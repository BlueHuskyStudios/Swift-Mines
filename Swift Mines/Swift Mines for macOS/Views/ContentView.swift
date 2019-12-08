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
    var baseStyle: Board.Style
    
    @State
    var game: Game
    
    var body: some View {
        BoardView(board: game.board.annotated(baseStyle: baseStyle))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(baseStyle: .default,
                    game: Game(board: Board(content: UIntSize(width: 10, height: 10).map2D { _ in .random() })))
    }
}
