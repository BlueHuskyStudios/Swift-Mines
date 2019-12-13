//
//  BoardView.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import RectangleTools
import SafePointer



internal struct BoardView: View {
    
    @State
    public var board: Board.Annotated {
        didSet {
            print("BoardView did update board")
        }
    }
    
    private var onSquareTapped = MutableSafePointer<OnSquareTapped?>(to: nil)
    
    
    internal init(board: Board.Annotated) {
        self.init(board: State(wrappedValue: board))
    }
    
    
    internal init(board: State<Board.Annotated>) {
        self._board = board
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                ForEach(self.board.content, id: \.self) { row in
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(row, id: \.self) { square in
                            BoardSquareView(
                                style: self.style(for: square),
                                model: square
                            )
                                .alsoForView { print("BoardView Did regenerate board square view at", square.cachedLocation) }
                                .gesture(TapGesture().modifiers(.control).onEnded({ self.onSquareTapped.pointee?(square, .placeFlag(style: nil)) }))
                                .gesture(TapGesture().onEnded({ self.onSquareTapped.pointee?(square, .dig) }))
                                .alsoForView { print("\tBoardView Did attach listeners to board square view at", square.cachedLocation) }
                        }
                    }
                }
            }
            .background(Color(self.board.style.baseColor))
        }
        .alsoForView { print("BoardView Did regenerate view with \(board.content.count * (board.content[orNil: 0]?.count ?? 1)) squares") }
    }
    
    
    
    public typealias OnSquareTapped = (_ square: BoardSquare.Annotated, _ action: Game.UserAction) -> Void
}



internal extension BoardView {
    
    func onSquareTapped(perform responder: @escaping OnSquareTapped) -> BoardView {
        self.onSquareTapped.pointee = { square, action in
            responder(square, action)
        }
        return self
    }
}



private extension BoardView {
    
    func handleUserDidTap(_ square: BoardSquare.Annotated) -> OnGestureDidEnd {{
        print("Tap")
        self.onSquareTapped.pointee?(square, .dig)
    }}
    
    
    func handleUserDidAltTap(_ square: BoardSquare.Annotated) -> OnGestureDidEnd {{
        print("Tap2")
        self.onSquareTapped.pointee?(square, .placeFlag(style: nil))
    }}
    
    
    func style(for square: BoardSquare.Annotated) -> BoardSquareView.Style {
        .init(
            actualColor: board.style.baseColor
        )
    }
    
    
    
    typealias OnGestureDidEnd = () -> Void
}



struct BoardView_Previews: PreviewProvider {
    
    static let test10x10Board = Board
        .generateNewBoard(size: UIntSize(width: 10, height: 10),
                          totalNumberOfMines: 10)
        .annotated(baseStyle: .default)
        .allRevealed(reason: .safelyRevealedAfterWin)
    
    static var previews: some View {
        BoardView(board: test10x10Board)
    }
}
