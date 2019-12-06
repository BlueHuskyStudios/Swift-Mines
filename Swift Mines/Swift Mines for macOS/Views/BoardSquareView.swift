//
//  BoardSquareView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import Cocoa



struct BoardSquareView: View {
    
    @State
    var color: NSColor
    
    @State
    var model: BoardSquare
    
    
    var body: some View {
        Image(currentImageName)
//            .renderingMode(.original)
            .resizable(resizingMode: .stretch)
//            .scaledToFit()
            .frame(minWidth: 8, idealWidth: 16, minHeight: 8, idealHeight: 16, alignment: .center)
            .aspectRatio(1, contentMode: .fit)
//            .padding(1)
            .background(Color(model.appropriateBackgroundColor(basedOn: color)))
    }
}



private extension BoardSquareView {
    var currentImageName: String {
        switch model.externalRepresentation {
        case .blank,
             .revealed(content: .farFromMine):
            return ""
            
        case .revealed(content: .closeTo1Mine),
             .revealed(content: .closeTo2Mines),
             .revealed(content: .closeTo3Mines),
             .revealed(content: .closeTo4Mines),
             .revealed(content: .closeTo5Mines),
             .revealed(content: .closeTo6Mines),
             .revealed(content: .closeTo7Mines),
             .revealed(content: .closeTo8Mines):
            return "" // TODO
            
        case .flagged(style: .sure):
            return "Flag"
            
        case .flagged(style: .unsure):
            return "Question Mark"
            
        case .revealed(content: .mine(revealReason: .manuallyTriggered)),
             .revealed(content: .mine(revealReason: .chainReaction)):
            switch model.content {
            case .mine:
                return "Mine (Detonated)"
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return ""
            }
            
        case .revealed(content: .mine(revealReason: .safelyDiscoveredAfterWin)):
            switch model.content {
            case .mine:
                return "Mine (Revealed)"
                
            case .clear:
                assertionFailure("Clear square with revealed mine")
                return ""
            }
        }
    }
}



private extension BoardSquare {
    func appropriateBackgroundColor(basedOn defaultColor: NSColor) -> NSColor {
        switch self.externalRepresentation {
        case .blank,
             .flagged(style: _):
            return defaultColor
            
        case .revealed(content: _):
            return defaultColor.withSystemEffect(.pressed)
        }
    }
}



struct BoardSquareView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BoardSquareView(
                color: NSColor(calibratedHue: (210/360), saturation: 0.74, brightness: 0.64, alpha: 1),
                model: BoardSquare(id: UUID(),
                                   content: .mine,
                                   externalRepresentation: .blank)
            )
            BoardSquareView(
                color: NSColor(calibratedHue: (210/360), saturation: 0.74, brightness: 0.64, alpha: 1),
                model: BoardSquare(id: UUID(),
                                   content: .mine,
                                   externalRepresentation: .flagged(style: .sure))
            )
        }
    }
}
