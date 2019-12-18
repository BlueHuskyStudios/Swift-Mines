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
    
    var onUserDidPressSquare: OnUserDidPressSquare?
    
    
    
    init(square: BoardSquare.Annotated, onUserDidPressSquare: OnUserDidPressSquare? = nil) {
        self.square = square
        self.onUserDidPressSquare = onUserDidPressSquare
        
        super.init(frame: .zero)
        
        updateUi()
        attachPressListeners()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    typealias OnUserDidPressSquare = (_ square: BoardSquare.Annotated, _ action: Game.UserAction) -> Void
}



private extension BoardSquareView {
    func updateUi() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
        self.layer?.borderColor = NSColor.quaternaryLabelColor.cgColor
        self.layer?.borderWidth = 1
    }
    
    
    func attachPressListeners() {
        let digGestureRecognizer = NSClickGestureRecognizer(target: self, action: #selector(userDidPressSquare_digGesture))
        digGestureRecognizer.buttonMask = 0b0001
        self.addGestureRecognizer(digGestureRecognizer)
    }
    
    
    @IBAction
    func userDidPressSquare_digGesture(sender: Any?) {
        onUserDidPressSquare?(square, .dig)
    }
}
