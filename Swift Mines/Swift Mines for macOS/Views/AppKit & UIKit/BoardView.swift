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



internal class BoardView: NSCollectionView {
    
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
        
        self.dataSource = self
        
        let layout = NSCollectionViewGridLayout()
        layout.maximumNumberOfColumns = Int(board.size.width)
        layout.maximumNumberOfRows = Int(board.size.height)
        self.collectionViewLayout = layout
        
        updateUi()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    typealias OnUserDidPressSquare = BoardSquareView.OnUserDidPressSquare
}



private extension BoardView {
    func updateUi() {
        squareViews.adjustSize(to: board.content.size, newElementGenerator: generateNewBoardSquareView)
//        layOutSquareViews()
        
        squareViews.mutateEachIndexed { row, rowIndex in
            row.mutateEachIndexed { boardSquareView, columnIndex in
                boardSquareView.square = board.content[rowIndex][columnIndex]
            }
        }
        
        self.reloadData()
    }
    
    
    private func generateNewBoardSquareView(at location: UIntPoint) -> BoardSquareView {
        return BoardSquareView(square: getBoardSquare(fromBoardAt: location),
                               onUserDidPressSquare: userDidPressSquare)
    }
    
    
    private func getBoardSquare(fromBoardAt location: UIntPoint) -> BoardSquare.Annotated {
        return board.content[location]
    }
    
    
    private func userDidPressSquare(_ square: BoardSquare.Annotated, action: Game.UserAction) {
        self.onUserDidPressSquare?(square, action)
    }
    
    
//    private func layOutSquareViews() { // TODO: Test
//        self.subviews = []
//
//        let eachSquareSideLength = self.bounds.size.minMeasurement / CGFloat(self.board.size.maxSideLength)
//        let eachSquareSize = CGSize(width: eachSquareSideLength, height: eachSquareSideLength)
//
//        @inline(__always)
//        func origin(forSquareAtRow rowIndex: CGFloat, column columnIndex: CGFloat) -> CGPoint {
//            CGPoint(x: columnIndex * eachSquareSize.width, y: rowIndex * eachSquareSize.height)
//        }
//
//        self.squareViews.mutateEachIndexed { row, rowIndex in
//            let rowIndexCgFloat = CGFloat(rowIndex)
//            row.mutateEachIndexed { squareView, columnIndex in
////                squareView.frame = CGRect(origin: origin(forSquareAtRow: rowIndexCgFloat, column: CGFloat(columnIndex)),
////                                          size: eachSquareSize)
////                self.addSubview(squareView)
//
//            }
//        }
//    }
}



internal extension BoardView {
    func onSquareTapped(_ responder: @escaping OnUserDidPressSquare) -> Self {
        self.onUserDidPressSquare = responder
        return self
    }
}



extension BoardView: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(board.size.area)
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let location = self.location(for: indexPath) else {
            preconditionFailure("Index path \(indexPath) does not model a square in a board of size \(board.size)")
        }
        
        return BoardSquareViewCollectionItem(self.squareViews[location])
    }
    
    
    private func location(for indexPath: IndexPath) -> UIntPoint? {
        return indexPath.asPoint(in: board.size, sectionRequirement: .onlyAllowSectionZero)
    }
    
    
    
    private class BoardSquareViewCollectionItem: NSCollectionViewItem {
        
        var boardSquareView: BoardSquareView {
            get {
                guard let superView = super.view as? BoardSquareView else {
                    preconditionFailure("Nothing should have set the view to anything other than a BoardSquareView (found \(type(of: super.view))")
                }
                return superView
            }
            set {
                super.view = newValue
            }
        }
        
        
        init(_ boardSquareView: BoardSquareView) {
            super.init(nibName: nil, bundle: nil)
            self.view = boardSquareView
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
