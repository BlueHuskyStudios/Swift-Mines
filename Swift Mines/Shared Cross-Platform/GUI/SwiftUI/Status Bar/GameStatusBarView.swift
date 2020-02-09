//
//  GameStatusBarView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-20.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import SwiftUI
import SevenSegmentDisplay
import RectangleTools
import SafePointer



/// The aspect ratio of each character in the displays
private let perCharacterRatio = CGSize(width: 10, height: 16)

private let gameTimeDisplayUpdateInterval: TimeInterval = 0.05

/// The minimum size of each display, in characters. The displays might become larger than this if that's necessary
/// to display what's needed, but they'll never become smaller than this.
private let minimumNumberOfCharactersPerDisplay = 4



/// The number of mines remaining, amount of time played, and the reset button
public struct GameStatusBarView: View {
    
    /// The overall app state, which this view can both observe and modify
    @EnvironmentObject
    var overallAppState: OverallAppState
    
    /// The function which is called when the New Game button is pressed
    let onNewGameButtonPressed: OnNewGameButtonPressed
    
    /// This updates the game time display
    private let updateTimer = Timer.publish(every: gameTimeDisplayUpdateInterval,
                                            on: .current,
                                            in: .common).autoconnect()

    /// The string to be displayed in the number of seconds game timer
    @State
    private var secondsReadout: String = "0"
    
    @State
    private var buttonImage = Image("")
    
    
    public var body: some View {GeometryReader { geometry in
            HStack(alignment: VerticalAlignment.center) {
                Spacer()
                
                SevenSegmentReadout(
                    resembling: self.playStateOrDisplayText(
                        from: self.overallAppState.game.numberOfFlagsRemainingToPlace,
                        playState: self.overallAppState.game.playState),
                    skew: .traditional)
                    .eachCharacterAspectRatio(perCharacterRatio)
                
                Button(action: self.onNewGameButtonPressed, label: { self.newGameButtonLabel(for: self.overallAppState.game) })
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
                    // TODO: .tooltip("Click to restart the game")
                
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
    
    
    /// Returns a string version of the given number, appropriately formatted for the readout displays
    ///
    /// This will take care of ensuring the string is at least long enough to fill the displays, and it might return
    /// a string that's longer if necessary
    ///
    /// - Parameter number: The number to be converted into a string for the display
    func displayText(from number: UInt) -> String {
        let numberString = number.description
        
        if numberString.count < minimumNumberOfCharactersPerDisplay {
            return number.description.padding(toLength: minimumNumberOfCharactersPerDisplay,
                                              withPad: " ",
                                              startingAt: 0)
        }
        else {
            return numberString
        }
    }
    
    
    /// Returns a string version of the given number, appropriately formatted for the readout displays, unless the
    /// current play state should be reflected in the returned string.
    ///
    /// Currently, the only play state that returns a special string is the win state. Otherwise, this behaves
    /// identically to `displayText(from:)`
    ///
    /// - Parameters:
    ///   - number:    The number to be converted into a string for the display, if the current play state allows
    ///   - playState: The current play state which might be reflected in the returned string
    func playStateOrDisplayText(from number: UInt, playState: Game.PlayState) -> String {
        switch playState {
        case .notStarted,
             .playing(startDate: _),
             .loss(startDate: _, lossDate: _):
            return displayText(from: number)
            
        case .win(startDate: _, winDate: _):
            return "YAY!"
        }
    }
    
    
    /// Generates a label appropriate for the New Game button
    ///
    /// - Parameter game: The current game, whose state will be reflected in the button
    func newGameButtonLabel(for game: Game) -> some View {
        GeometryReader { geometry in
            Text(verbatim: self.buttonString(for: game.playState))
                .font(Font.system(size: geometry.size.minSideLength * 0.5))
                .position(geometry.size.center())
        }
        .border(SeparatorShapeStyle(), width: 2)
        .background(Color.accentColor)
    }
    
    
    /// The string to display on the New Game button
    ///
    /// - Parameter playState: The current game's play state
    func buttonString(for playState: Game.PlayState) -> String {
        switch self.overallAppState.game.playState {
        case .notStarted:                      return "😴"
        case .playing(startDate: _):           return "🙂"
        case .win(startDate: _, winDate: _):   return "😎"
        case .loss(startDate: _, lossDate: _): return "😵"
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
