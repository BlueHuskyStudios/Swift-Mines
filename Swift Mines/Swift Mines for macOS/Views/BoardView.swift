//
//  BoardView.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import RectangleTools



struct BoardView: View {
    
    @State
    public var board: Board.Annotated
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(board.content, id: \.self) { row in
                HStack(alignment: .center, spacing: 0) {
                    ForEach(row) { square in
                        BoardSquareView(
                            style: self.style(for: square),
                            model: square
                        )
                    }
                }
            }
        }
    }
}



private extension BoardView {
    func style(for square: BoardSquare.Annotated) -> BoardSquareView.Style {
        .init(
            actualColor: board.style.baseColor
        )
    }
}



struct BoardView_Previews: PreviewProvider {
    
    static let test10x10Board = Board.random(size: UIntSize(width: 10, height: 10)).annotated(baseStyle: .default)
    
    static var previews: some View {
        BoardView(board: test10x10Board)
    }
}
