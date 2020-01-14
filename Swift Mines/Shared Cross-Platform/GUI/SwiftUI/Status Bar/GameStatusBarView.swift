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
    
    @EnvironmentObject
    var overallAppState: OverallAppState
    
    let onNewGameButtonPressed: OnNewGameButtonPressed
    
    private let updateTimer = Timer.publish(every: 0.05, on: .current, in: .common).autoconnect()

    @State
    private var secondsReadout: String = "0"
    
    @State
    private var buttonImage = Image("")
    
    
    var body: some View {GeometryReader { geometry in
            HStack(alignment: VerticalAlignment.center) {
                Spacer()
                
                SevenSegmentReadout(resembling: self.displayText(from: self.overallAppState.game.numberOfFlagsRemainingToPlace),
                                    skew: .traditional)
                    .eachCharacterAspectRatio(perCharacterRatio)
                
                Button(action: self.onNewGameButtonPressed, label: { self.buttonLabel(for: self.overallAppState.game) })
                    .buttonStyle(PlainButtonStyle())
                    .aspectRatio(1, contentMode: .fit)
                    .frame(minWidth: geometry.size.minSideLength * 0.75,
                           idealWidth: geometry.size.minSideLength * 0.8,
                           minHeight: geometry.size.minSideLength * 0.75,
                           idealHeight: geometry.size.minSideLength * 0.8,
                           alignment: .center)
                    .padding(EdgeInsets(top: 0,
                                        leading: geometry.size.minSideLength / 16,
                                        bottom: 0,
                                        trailing: geometry.size.minSideLength / 16))
                
                SevenSegmentReadout(resembling: self.secondsReadout, skew: .traditional)
                    .eachCharacterAspectRatio(perCharacterRatio)
                    .onReceive(self.updateTimer) { _ in
                        self.secondsReadout = self.displayText(from: self.overallAppState.game.numberOfSecondsSinceGameStarted)
                    }
                
                Spacer()
            }
            .padding(Edge.Set.all, max(4, geometry.size.minSideLength / 12))
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
        switch self.overallAppState.game.playState {
        case .notStarted: return Text(verbatim: "😴")
        case .playing(startDate: _): return Text(verbatim: "🙂")
        case .win(startDate: _, winDate: _): return Text(verbatim: "😎")
        case .loss(startDate: _, lossDate: _): return Text(verbatim: "😵")
        }
    }
    
    
    
    public typealias OnNewGameButtonPressed = () -> Void
}

struct GameStatusBarView_Previews: PreviewProvider {
    
    @EnvironmentObject
    static var overallAppState: OverallAppState
    
    static var previews: some View {
        overallAppState.game = Game.new(size: Board.Size(width: 10, height: 10))
        
        return GameStatusBarView() {}
    }
}
