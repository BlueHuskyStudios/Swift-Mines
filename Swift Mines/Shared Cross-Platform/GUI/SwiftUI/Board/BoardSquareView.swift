//
//  BoardSquareView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import SwiftUI
import Cocoa
import CrossKitTypes
import RectangleTools



/// This view represents a square on a board
internal struct BoardSquareView: View {
    
    /// The current model representing this board square
    @State
    var model: Model {
        didSet {
            print("BoardSquareView did set square")
        }
    }
    
    
    var body: some View {
        GeometryReader { geometryProxy in
            Image(nsImage: self.model.imageForUi(size: geometryProxy.size))
                .resizable(resizingMode: .stretch)
                .background(Color(self.model.appropriateBackgroundColor()))
        }
        .border(SeparatorShapeStyle(), width: 1)
        .frame(minWidth: 8, idealWidth: 16, minHeight: 8, idealHeight: 16, alignment: .center)
    }
    
    
    
    typealias Model = BoardSquare.Annotated
}



extension BoardSquareView: Identifiable {
    @inlinable
    var id: UUID { model.id }
}



extension BoardSquareView: Hashable {
    static func == (lhs: BoardSquareView, rhs: BoardSquareView) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        model.hash(into: &hasher)
    }
}



// MARK: - Style

internal extension BoardSquareView {
    struct Style {
        let actualColor: NativeColor
    }
}



extension BoardSquareView.Style: Equatable {}



extension BoardSquareView.Style: Hashable {}



// MARK: - Preview

struct BoardSquareView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                preview(name: "Unclicked",
                        context: .mine,
                        representation: .blank)
            }
            
            
            Group {
                preview(name: "Clear (1)",
                        context: .clear(proximity: .closeTo1Mine),
                        representation: .revealed(reason: .manual))
                preview(name: "Clear (2)",
                        context: .clear(proximity: .closeTo2Mines),
                        representation: .revealed(reason: .manual))
                preview(name: "Clear (3)",
                        context: .clear(proximity: .closeTo3Mines),
                        representation: .revealed(reason: .manual))
                preview(name: "Clear (4)",
                        context: .clear(proximity: .closeTo4Mines),
                        representation: .revealed(reason: .manual))
                preview(name: "Clear (5)",
                        context: .clear(proximity: .closeTo5Mines),
                        representation: .revealed(reason: .manual))
                preview(name: "Clear (6)",
                        context: .clear(proximity: .closeTo6Mines),
                        representation: .revealed(reason: .manual))
                preview(name: "Clear (7)",
                        context: .clear(proximity: .closeTo7Mines),
                        representation: .revealed(reason: .manual))
                preview(name: "Clear (8)",
                        context: .clear(proximity: .closeTo8Mines),
                        representation: .revealed(reason: .manual))
            }
            
            
            Group {
                preview(name: "Flag",
                        context: .mine,
                        representation: .flagged(style: .sure))
                preview(name: "Unsure",
                        context: .mine,
                        representation: .flagged(style: .unsure))
            }
            
            
            Group {
                preview(name: "Mine (Safely Revealed)",
                        context: .mine,
                        representation: .revealed(reason: .safelyRevealedAfterWin))
                preview(name: "Mine (Chain Reaction)",
                        context: .mine,
                        representation: .revealed(reason: .chainReaction))
                preview(name: "Manually Triggered Mine",
                        context: .mine,
                        representation: .revealed(reason: .manual))
            }
        }
    }
    
    
    
    private static func preview(name: String,
                                context: BoardSquare.MineContext,
                                representation: BoardSquare.ExternalRepresentation) -> some View {
        BoardSquareView(
            model: .init(base: BoardSquare(id: UUID(),
                                           content: content(from: context),
                                           externalRepresentation: representation),
                         inheritedStyle: .default,
                         mineContext: context,
                         cachedLocation: .zero))
            .previewDisplayName(name)
            .frame(width: 16, height: 16, alignment: .center)
    }
    
    
    private static func content(from context: BoardSquare.MineContext) -> BoardSquare.Content {
        switch context {
        case .clear(proximity: _): return .clear
        case .mine:                return .mine
        }
    }
}
