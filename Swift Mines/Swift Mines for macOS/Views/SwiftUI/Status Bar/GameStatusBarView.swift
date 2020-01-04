//
//  GameStatusBarView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-20.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import SevenSegmentDisplay
import RectangleTools
import SafePointer



private let perCharacterRatio = CGSize(width: 10, height: 16)



struct GameStatusBarView: View {
    
    @MutableSafePointer
    var game: Game
    
    
    var body: some View {
        return GeometryReader { geometry in
            HStack(alignment: VerticalAlignment.center) {
                Spacer()
                
                SevenSegmentReadout(resembling: self.displayText(from: self.game.numberOfMinesRemainingToFind))
                    .eachCharacterAspectRatio(perCharacterRatio)
                
                Button(action: {}, label: { Color.yellow })
                    .buttonStyle(PlainButtonStyle())
                    .aspectRatio(1, contentMode: .fit)
                    .padding(EdgeInsets(top: geometry.size.minSideLength / 8,
                                        leading: geometry.size.minSideLength / 16,
                                        bottom: geometry.size.minSideLength / 8,
                                        trailing: geometry.size.minSideLength / 16))
                
                SevenSegmentReadout(resembling: self.displayText(from: self.game.numberOfSecondsSinceGameStarted))
                    .eachCharacterAspectRatio(perCharacterRatio)
                
                Spacer()
            }
            .padding(.all, max(4, geometry.size.minSideLength / 32))
        }
    }
    
    
    func displayText(from number: UInt) -> String {
        return number.description.padding(toLength: 4, withPad: " ", startingAt: 0)
    }
}

struct GameStatusBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameStatusBarView(game: Game.new(size: UIntSize(width: 10, height: 10), totalNumberOfMines: 10))
    }
}
