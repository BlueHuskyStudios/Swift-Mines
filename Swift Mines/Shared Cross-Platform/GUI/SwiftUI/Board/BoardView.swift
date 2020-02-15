//
//  BoardView.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import SwiftUI
import RectangleTools
import SafePointer



/// This view displays and mutates a game's board
internal struct BoardView: View {
    
    /// The app's overall state, which this board view will observe and mutate as the user interacts with it
    @EnvironmentObject
    var overallAppState: OverallAppState
    
    /// Called when a square is tapped
    private var onSquareTapped = MutableSafePointer<OnSquareTapped?>(to: nil)
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.overallAppState.game.board.content, id: \.self) { row in
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(row, id: \.self) { square in
                            BoardSquareView(
//                                style: self.style(for: square),
                                model: square
                            )
//                                .also { print(square.cachedLocation.humanReadableDescription, square.base.externalRepresentation) }
                                .gesture(TapGesture().modifiers(.control).onEnded({ _ in self.onSquareTapped.pointee?(square, .placeFlag(style: .automatic)) }))
                                .gesture(TapGesture().onEnded({ self.onSquareTapped.pointee?(square, .dig) }))
                                .onLongPressGesture { self.onSquareTapped.pointee?(square, .placeFlag(style: .automatic)) }
//                                .also { print("\tBoardView Did attach listeners to board square view at", square.cachedLocation.humanReadableDescription) }
                        }
                    }
                }
            }
            .background(Color(self.overallAppState.game.board.style.baseColor))
        }
//        .also { print("BoardView Did regenerate view with \(overallAppState.game.board.content.size.area) squares") }
    }
    
    
    
    public typealias OnSquareTapped = (_ square: BoardSquare.Annotated, _ action: Game.UserAction) -> Void
}



internal extension BoardView {
    
    /// Attach the given function as the one which will respond to the user clicking any square
    ///
    /// - Parameter responder: Called when the user clicking any square
    func onSquareTapped(perform responder: @escaping OnSquareTapped) -> BoardView {
        self.onSquareTapped.pointee = { square, action in
            responder(square, action)
        }
        return self
    }
}
