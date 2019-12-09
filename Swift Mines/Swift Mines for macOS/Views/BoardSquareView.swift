//
//  BoardSquareView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import Cocoa
import CrossKitTypes



struct BoardSquareView: View {
    
    @State
    var style: Style?
    
    @State
    var model: BoardSquare.Annotated
    
    
    var body: some View {
        GeometryReader { geometryProxy in
            Image.init(nsImage: self.currentImage(size: geometryProxy.size))
    //            .renderingMode(.original)
                .resizable(resizingMode: .stretch)
    //            .scaledToFit()
                .frame(minWidth: 8, idealWidth: 16, minHeight: 8, idealHeight: 16, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
    //            .padding(1)
                .background(Color(self.model.appropriateBackgroundColor()))
            }
    }
}



private extension BoardSquareView {
    
    func currentImage(size: CGSize) -> NativeImage {
        let image = currentImageWithoutResize
        image.size = size
        return image
    }
    
    
    var currentImageWithoutResize: NativeImage {
        currentImageName.flatMap(NativeImage.init(named:)) ?? .blank()
    }
    
    
    var currentImageName: NativeImage.Name? {
        switch (model.base.externalRepresentation, model.mineContext) {
        case (.blank, _),
             (.revealed(reason: _), .clear(.farFromMine)):
            return nil
            
        case (.revealed(reason: _), .clear(distance: .closeTo1Mine)),
             (.revealed(reason: _), .clear(distance: .closeTo2Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo3Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo4Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo5Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo6Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo7Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo8Mines)):
            return nil // TODO
            
        case (.flagged(style: .sure), _):
            return "Flag"
            
        case (.flagged(style: .unsure), _):
            return "Question Mark"
            
        case (.revealed(reason: .manuallyTriggered), .mine):
            switch model.base.content {
            case .mine:
                return "Mine (Detonated)"
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return nil
            }
            
        case (.revealed(reason: .safelyRevealedAfterWin), .mine),
             (.revealed(reason: .chainReaction), .mine):
            switch model.base.content {
            case .mine:
                return "Mine (Revealed)"
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return nil
            }
        }
    }
}



private extension BoardSquare.Annotated {
    func appropriateBackgroundColor() -> NSColor {
        switch self.base.externalRepresentation {
        case .blank,
             .flagged(style: _):
            return inheritedStyle.baseColor
            
        case .revealed:
            return inheritedStyle.baseColor.withSystemEffect(.pressed)
        }
    }
}



extension BoardSquareView {
    struct Style {
        let actualColor: NativeColor
    }
}



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
                        context: .clear(distance: .closeTo1Mine),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (2)",
                        context: .clear(distance: .closeTo2Mines),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (3)",
                        context: .clear(distance: .closeTo3Mines),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (3)",
                        context: .clear(distance: .closeTo3Mines),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (4)",
                        context: .clear(distance: .closeTo4Mines),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (5)",
                        context: .clear(distance: .closeTo5Mines),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (6)",
                        context: .clear(distance: .closeTo6Mines),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (7)",
                        context: .clear(distance: .closeTo7Mines),
                        representation: .revealed(reason: .manuallyTriggered))
                preview(name: "Clear (8)",
                        context: .clear(distance: .closeTo8Mines),
                        representation: .revealed(reason: .manuallyTriggered))
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
                        representation: .revealed(reason: .manuallyTriggered))
            }
        }
    }
    
    
    
    private static func preview(name: String,
                                context: BoardSquare.MineContext,
                                representation: BoardSquare.ExternalRepresentation) -> some View {
        BoardSquareView(
            style: nil,
            model: .init(base: BoardSquare(id: UUID(),
                                           content: content(from: context),
                                           externalRepresentation: representation),
                         inheritedStyle: .default,
                         mineContext: context))
        .previewDisplayName(name)
    }
    
    
    private static func content(from context: BoardSquare.MineContext) -> BoardSquare.Content {
        switch context {
        case .clear(distance: _): return .clear
        case .mine:               return .mine
        }
    }
}
