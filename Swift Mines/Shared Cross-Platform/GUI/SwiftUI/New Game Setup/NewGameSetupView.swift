//
//  NewGameSetupView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import SwiftUI
import SafePointer



private let defaultConfiguration = NewGameConfiguration.default



struct NewGameSetupView: View {
    
    @EnvironmentObject
    private var overallAppState: OverallAppState
    
    @State
    fileprivate var customGameConfiguration: NewGameConfiguration = defaultConfiguration
    
    @State
    fileprivate var selectedDifficultyIndex = 0
    
    private var maxNumberOfMines: CGFloat {
        CGFloat(customGameConfiguration.boardSize.width * customGameConfiguration.boardSize.height) / 2
    }
    
    
    private var selectedCustomBoardWidth: UInt {
        get {
            customGameConfiguration.boardSize.width
        }
        nonmutating set {
            customGameConfiguration.boardSize.width = newValue
        }
    }
    
    private var selectedCustomBoardHeight: UInt {
        get {
            customGameConfiguration.boardSize.height
        }
        nonmutating set {
            customGameConfiguration.boardSize.height = newValue
        }
    }
    
    private var selectedCustomNumberOfMines: CGFloat {
        get {
            CGFloat(customGameConfiguration.numberOfMines.count(in: customGameConfiguration.boardSize))
        }
        nonmutating set {
            customGameConfiguration.numberOfMines = .custom(count: UInt(newValue))
        }
    }
    
    
    public init() {}
    
    
    fileprivate init(customGameConfiguration: NewGameConfiguration, selectedDifficulty: DifficultySelection) {
        self.customGameConfiguration = customGameConfiguration
        self.selectedDifficultyIndex = DifficultySelection.allCases.firstIndex(of: selectedDifficulty) ?? 0
    }
    
    
    @MutableSafePointer
    private var setLock = false
    
    
    var body: some View {
        Form {
            Text("New Game")
                .font(Font.title.bold())
            
            Picker("Difficulty", selection: $selectedDifficultyIndex) {
                ForEach(DifficultySelection.allCases.indices) { difficultyIndex in
                    Text(DifficultySelection.allCases[difficultyIndex].displayName)
                        .tag(difficultyIndex)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if PredefinedGameDifficulty.allCases.indices.contains(selectedDifficultyIndex) {
                Text(verbatim: descriptionOfDifficulty)
                    .controlSize(.small)
                    .foregroundColor(.secondary)
            }
            else {
                Group {
                    HStack(alignment: .top) {
                        NumberPicker(label: "Width", value: Binding(
                            get: { self.selectedCustomBoardWidth },
                            set: { self.selectedCustomBoardWidth = $0 }
                        ), range: 6...200)
                        Text("×")
                        NumberPicker(label: "Height", value: Binding(
                            get: { self.selectedCustomBoardHeight },
                            set: { self.selectedCustomBoardHeight = $0 }
                        ), range: 6...200)
                    }
                    
                    Slider(value:  Binding(
                        get: { self.selectedCustomNumberOfMines },
                        set: { self.selectedCustomNumberOfMines = $0 }
                        ),
                           in: 2 ... maxNumberOfMines,
                           step: 1)
                    HStack(alignment: .center) {
                        Spacer()
                        Text("\(Int(selectedCustomNumberOfMines)) Mines").fontWeight(.medium).controlSize(.small)
                        Spacer()
                    }
                    
                }
                .accessibility(label: Text("Custom Board settings"))
            }
            
            Spacer(minLength: 24)
                .frame(maxHeight: 24, alignment: .center)
            
            HStack {
                Spacer()
                NativeButton("Cancel", keyEquivalent: .escape) {
                    self.overallAppState.currentScreen = .game
                }
                NativeButton("Start New Game", keyEquivalent: .return) {
                    self.overallAppState.game.startNewGame(configuration: self.selectedGameConfiguration)
                    self.overallAppState.currentScreen = .game
                }
                    .buttonStyle(DefaultButtonStyle())
            }
        }
        .padding()
    }
    
    
    var descriptionOfDifficulty: String {
        "A \(selectedGameConfiguration.boardSize.humanReadableDescription) board with \(selectedGameConfiguration.countNumberOfMines) mines"
    }
    
    
    var selectedGameConfiguration: NewGameConfiguration {
        switch DifficultySelection.allCases[orNil: selectedDifficultyIndex] {
        case .none, .custom:
            return NewGameConfiguration(
                boardSize: Board.Size(width: selectedCustomBoardWidth,
                                      height: selectedCustomBoardHeight),
                numberOfMines: .custom(count: UInt(selectedCustomNumberOfMines))
            )
            
        case .predefined(let difficulty):
            return NewGameConfiguration(difficulty: difficulty)
        }
    }
}



extension NewGameSetupView {
    func configuration(_ newConfiguration: NewGameConfiguration) -> Self {
        Self.init(customGameConfiguration: newConfiguration, selectedDifficulty: .custom)
    }
}



private extension NewGameSetupView {
    /// The different difficulties that the user can select with this view
    enum DifficultySelection: CaseIterable, Equatable {
        
        /// Use one of the predefined game difficulties
        case predefined(difficulty: PredefinedGameDifficulty)
        
        /// Let the user configure a custom game
        case custom
        
        
        var displayName: String {
            switch self {
            case .predefined(let difficulty): return difficulty.displayName
            case .custom: return "Custom"
            }
        }
        
        
        static let allCases: [DifficultySelection] =
            PredefinedGameDifficulty.allCases.map { DifficultySelection.predefined(difficulty: $0) }
                + [.custom]
    }
}



struct NewGameSetupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewGameSetupView()
                .previewDisplayName("Default")
            
            NewGameSetupView().configuration(.easy)
                .previewDisplayName("Easy")
            
            NewGameSetupView().configuration(.intermediate)
                .previewDisplayName("Intermediate")
            
            NewGameSetupView().configuration(.advanced)
                .previewDisplayName("Advanced")
            
            
            NewGameSetupView().configuration(NewGameConfiguration(boardSize: Board.Size(width: 5, height: 30), numberOfMines: 2))
                .previewDisplayName("Custom")
        }
        .previewLayout(.fixed(width: 400, height: 999))
    }
}
