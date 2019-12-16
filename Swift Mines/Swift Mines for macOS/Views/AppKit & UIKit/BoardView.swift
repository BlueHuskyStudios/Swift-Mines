//
//  BoardView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-15.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

#if canImport(Cocoa)
import Cocoa
#elseif canImport(CocoaTouch)
#error("TODO: CocoaTouch support")
#endif

import RectangleTools



internal class BoardView: NSView {
    
    var board: Board.Annotated {
        didSet {
            updateUi()
        }
    }
    
    private var squareViews = [[BoardSquareView]]()
    
    var onUserDidPressSquare: OnUserDidPressSquare?
    
    
    
    init(board: Board.Annotated, onUserDidPressSquare: OnUserDidPressSquare? = nil) {
        self.board = board
        self.onUserDidPressSquare = onUserDidPressSquare
        
        super.init(frame: .zero)
        
        updateUi()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    typealias OnUserDidPressSquare = BoardSquareView.OnUserDidPressSquare
}



private extension BoardView {
    func updateUi() {
        print("TODO: Update UI")
//        squareViews.adjustSize(to: board.content.size, newElementGenerator: generateNewBoardSquareView)
    }
    
    
    func generateNewBoardSquareView(at location: UIntPoint) -> BoardSquareView {
        fatalError("TODO")
//        <#function body#>
    }
}



internal extension BoardView {
    func onSquareTapped(_ responder: @escaping OnUserDidPressSquare) -> Self {
        self.onUserDidPressSquare = responder
        return self
    }
}
