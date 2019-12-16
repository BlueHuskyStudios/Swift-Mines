//
//  BoardSquareView.swift
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



internal class BoardSquareView: NSView {
    var square: BoardSquare.Annotated {
        didSet {
            updateUi()
        }
    }
    
    var onUserDidClickSquare: OnUserDidPressSquare?
    
    
    
    init(square: BoardSquare.Annotated, onUserDidClickSquare: OnUserDidPressSquare? = nil) {
        self.square = square
        self.onUserDidClickSquare = onUserDidClickSquare
        
        super.init(frame: .zero)
        
        updateUi()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    typealias OnUserDidPressSquare = (_ square: BoardSquare.Annotated, _ action: Game.UserAction) -> Void
}



private extension BoardSquareView {
    func updateUi() {
        print("TODO: Update UI")
    }
}
