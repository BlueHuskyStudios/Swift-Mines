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

import CrossKitTypes



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



// MARK: - Functionality

private extension BoardSquareView {
    func updateUi() {
        self.wantsLayer = true
        layer?.backgroundColor = square.appropriateBackgroundColor().cgColor
        layer?.borderColor = NSColor.quaternaryLabelColor.cgColor
        layer?.borderWidth = 1
        var zeroOriginFrame = frame.withOriginZero
        layer?.contents = square
            .imageForUi(size: frame.size)
            .cgImage(forProposedRect: &zeroOriginFrame, context: .current, hints: nil)
        layer?.contentsGravity = .resizeAspect
    }
    
    
    func attachPressListeners() {
        let digGestureRecognizer = NSClickGestureRecognizer(target: self, action: #selector(userDidPressSquare_digGesture))
        digGestureRecognizer.buttonMask = 0b0001
        self.addGestureRecognizer(digGestureRecognizer)
    }
}



// MARK: - Actions

private extension BoardSquareView {
    
    @IBAction
    func userDidPressSquare_digGesture(sender: Any?) {
        onUserDidPressSquare?(square, .dig)
    }
}
