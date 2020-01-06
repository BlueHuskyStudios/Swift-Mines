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
    
    let onNewGameButtonPressed: OnNewGameButtonPressed
    
    private let updateTimer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()

    @State
    private var secondsReadout: String = "0"
    
    @State
    private var buttonImage = Image("")
    
    
    var body: some View {
        return GeometryReader { geometry in
            HStack(alignment: VerticalAlignment.center) {
                Spacer()
                
                SevenSegmentReadout(resembling: self.displayText(from: self.game.numberOfFlagsRemainingToPlace),
                                    skew: .traditional)
                    .eachCharacterAspectRatio(perCharacterRatio)
                
                Button(action: self.onNewGameButtonPressed, label: { self.buttonLabel(for: self.game) })
                    .buttonStyle(PlainButtonStyle())
                    .aspectRatio(1, contentMode: .fit)
                    .frame(minWidth: geometry.size.minSideLength * 0.75,
                           idealWidth: geometry.size.minSideLength * 0.8,
                           minHeight: geometry.size.minSideLength * 0.75,
                           idealHeight: geometry.size.minSideLength * 0.8,
                           alignment: .center)
                    .padding(EdgeInsets(top: geometry.size.minSideLength / 8,
                                        leading: geometry.size.minSideLength / 16,
                                        bottom: geometry.size.minSideLength / 8,
                                        trailing: geometry.size.minSideLength / 16))
                
                SevenSegmentReadout(resembling: self.secondsReadout, skew: .traditional)
                    .eachCharacterAspectRatio(perCharacterRatio)
                    .onReceive(self.updateTimer) { _ in
                        self.secondsReadout = self.displayText(from: self.game.numberOfSecondsSinceGameStarted)
                    }
                
                Spacer()
            }
            .padding(Edge.Set.all, max(4, geometry.size.minSideLength / 32))
        }
    }
    
    
    func displayText(from number: UInt) -> String {
        return number.description.padding(toLength: 4, withPad: " ", startingAt: 0)
    }
    
    
    func buttonLabel(for game: Game) -> some View {
        GeometryReader { geometry in
            ZStack {
                self.buttonText(for: game.playState)
                    .position(geometry.size.center())
            }
        }
        .border(SeparatorShapeStyle(), width: 2)
        .background(Color.accentColor)
    }
    
    
    func buttonText(for playState: Game.PlayState) -> some View {
        switch self.game.playState {
        case .notStarted: return Text(verbatim: "😴")
        case .playing(startDate: _): return Text(verbatim: "🙂")
        case .win(startDate: _, winDate: _): return Text(verbatim: "😎")
        case .loss(startDate: _, lossDate: _): return Text(verbatim: "😵")
        }
    }
    
    
    
    public typealias OnNewGameButtonPressed = () -> Void
}

struct GameStatusBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameStatusBarView(
            game: Game.new(size: UIntSize(width: 10, height: 10), totalNumberOfMines: 10),
            onNewGameButtonPressed: { }
        )
    }
}
