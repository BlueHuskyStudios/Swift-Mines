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
        Image(currentImageName)
//            .renderingMode(.original)
            .resizable(resizingMode: .stretch)
//            .scaledToFit()
            .frame(minWidth: 8, idealWidth: 16, minHeight: 8, idealHeight: 16, alignment: .center)
            .aspectRatio(1, contentMode: .fit)
//            .padding(1)
            .background(Color(model.appropriateBackgroundColor()))
    }
}



private extension BoardSquareView {
    var currentImageName: String {
        switch (model.base.externalRepresentation, model.mineContext) {
        case (.blank, _),
             (.revealed(reason: _), .clear(.farFromMine)):
            return ""
            
        case (.revealed(reason: _), .clear(distance: .closeTo1Mine)),
             (.revealed(reason: _), .clear(distance: .closeTo2Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo3Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo4Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo5Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo6Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo7Mines)),
             (.revealed(reason: _), .clear(distance: .closeTo8Mines)):
            return "" // TODO
            
        case (.flagged(style: .sure), _):
            return "Flag"
            
        case (.flagged(style: .unsure), _):
            return "Question Mark"
            
        case (.revealed(reason: .manuallyTriggered), .mine),
             (.revealed(reason: .chainReaction), .mine):
            switch model.base.content {
            case .mine:
                return "Mine (Detonated)"
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return ""
            }
            
        case (.revealed(reason: .safelyRevealedAfterWin), .mine):
            switch model.base.content {
            case .mine:
                return "Mine (Revealed)"
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return ""
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
            BoardSquareView(
                style: nil,
                model: .init(base: BoardSquare(id: UUID(),
                                               content: .mine,
                                               externalRepresentation: .blank),
                             inheritedStyle: .default,
                             mineContext: .mine)
            )
            BoardSquareView(
                style: nil,
                model: .init(base: BoardSquare(id: UUID(),
                                               content: .mine,
                                               externalRepresentation: .flagged(style: .sure)),
                             inheritedStyle: .default,
                             mineContext: .mine)
            )
        }
    }
}
