//
//  NewGameSetupView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI

struct NewGameSetupView: View {
    
    @EnvironmentObject
    private var overallAppState: OverallAppState
    
    
    @State
    private var selectedDifficultyIndex = 0
    
    @State
    private var selectedCustomBoardWidth: UInt = 10
    
    @State
    private var selectedCustomBoardHeight: UInt = 10
    
    
    var body: some View {
        Form {
            Text("New Game")
                .font(Font.title.bold())
            
            Picker("Difficulty", selection: $selectedDifficultyIndex) {
                ForEach(GameDifficulty.allCases.indices) { difficultyIndex in
                    Text(verbatim: GameDifficulty.allCases[difficultyIndex].rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            HStack {
                TextField("Board Width", value: $selectedCustomBoardWidth, formatter: NumberFormatter())
            }
//            .disabled(selectedDifficultyIndex != GameDifficulty.allCases.firstIndex(of: .custom))
            .isHidden(selectedDifficultyIndex != GameDifficulty.allCases.firstIndex(of: .custom))
            
            Button("OK", action: { self.overallAppState.currentScreen = .game })
        }
        .padding()
    }
}



struct NewGameSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameSetupView()
    }
}
