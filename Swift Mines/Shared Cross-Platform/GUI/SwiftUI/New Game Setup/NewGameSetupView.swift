//
//  NewGameSetupView.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-11.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import SwiftUI
import SafePointer



/// A view to let the user set up a new game
///
/// ```
///            New Game
///            ┏━━━━━━┱──────────────┬──────────┬────────┐
/// Difficulty ┃ Easy ┃ Intermediate │ Advanced │ Custom │
///            ┗━━━━━━┹──────────────┴──────────┴────────┘
///
///            A (10 × 10) board with 10 mines
/// ```
/// ---
/// ```
///            New Game
///            ┌──────┬──────────────┬──────────┲━━━━━━━━┓
/// Difficulty │ Easy │ Intermediate │ Advanced ┃ Custom ┃
///            └──────┴──────────────┴──────────┺━━━━━━━━┛
///
///            Board Size
///            ┌────────────────┐ ▲   ┌────────────────┐ ▲
///            │ 10             │   × │ 10             │
///            └────────────────┘ ▼   └────────────────┘ ▼
///                  Width                  Height
///
///            Number of Mines
///            ◻️ Auto (10)
///  10 Mines  ────────▽──────────────────────────────────
///            ╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵╵
/// ```
///
/// - Attention: This requires an `OverallAppState` environment object, and it will mutate that object once the user
///              presses "Start New Game"
public struct NewGameSetupView: View {
    
    /// The state of the app which will both build and
    @EnvironmentObject
    private var overallAppState: OverallAppState
    
    /// The configuration that the user would specify if they selects the "Custom" difficulty
    @State
    fileprivate var customGameConfiguration = NewGameConfiguration.default
    
    /// The index of the segment of the difficulty selector that the user has selected
    @State
    fileprivate var selectedDifficultyIndex = 0
    
    /// The maximum number of mines that the user can select
    private var minNumberOfMines: CGFloat {
        CGFloat(customGameConfiguration.boardSize.area).squareRoot() / 2
    }
    
    /// The maximum number of mines that the user can select
    private var maxNumberOfMines: CGFloat {
        CGFloat(customGameConfiguration.boardSize.area) / 2
    }
    
    
    /// The width that the user selected in the custom difficulty screen
    private var selectedCustomBoardWidth: UInt {
        get {
            customGameConfiguration.boardSize.width
        }
        nonmutating set {
            customGameConfiguration.boardSize.width = newValue
        }
    }
    
    /// The height that the user selected in the custom difficulty screen
    private var selectedCustomBoardHeight: UInt {
        get {
            customGameConfiguration.boardSize.height
        }
        nonmutating set {
            customGameConfiguration.boardSize.height = newValue
        }
    }
    
    /// Whether the user wants their custom game to use an automatic amount of mines
    @State
    private var shouldUseAutomaticMineCount: Bool = true
    
    /// The number of mines that the user selected in the custom difficulty screen
    private var selectedCustomNumberOfMines: CGFloat {
        get {
            CGFloat(customGameConfiguration.numberOfMines.count(in: customGameConfiguration.boardSize))
        }
        nonmutating set {
            shouldUseAutomaticMineCount = false
            customGameConfiguration.numberOfMines = .custom(count: UInt(newValue))
        }
    }
    
    
    public init() {}
    
    
    fileprivate init(customGameConfiguration: NewGameConfiguration, selectedDifficulty: DifficultySelection) {
        self.customGameConfiguration = customGameConfiguration
        self.selectedDifficultyIndex = DifficultySelection.allCases.firstIndex(of: selectedDifficulty) ?? 0
    }
    
    
    public var body: some View {
        Form {
            Text("New Game")
                .font(.title)
                .fontWeight(.bold)
            
            Picker("Difficulty", selection: $selectedDifficultyIndex) {
                ForEach(DifficultySelection.allCases.indices) { difficultyIndex in
                    Text(DifficultySelection.allCases[difficultyIndex].displayName)
                        .tag(difficultyIndex)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if PredefinedGameDifficulty.allCases.indices.contains(selectedDifficultyIndex) {
                Text(descriptionOfDifficulty)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            else {
                Spacer(minLength: 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                Group {
                    Group {
                        Text("Board Size").font(Font.headline)
                        
                        HStack(alignment: .center) {
                            NumberPicker("Width",
                                         value: Binding(
                                             get: { self.selectedCustomBoardWidth },
                                             set: { self.selectedCustomBoardWidth = $0 }
                                         ),
                                         range: 6...200)
                            
                            Text("×")
                            
                            NumberPicker("Height",
                                         value: Binding(
                                             get: { self.selectedCustomBoardHeight },
                                             set: { self.selectedCustomBoardHeight = $0 }
                                         ),
                                         range: 6...200)
                        }
                    }
                    
                    Spacer(minLength: 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Number of Mines").font(Font.headline)
                    
                    Toggle(isOn: $shouldUseAutomaticMineCount, label: {
                        Text("Auto")
                        Text("(\(customGameConfiguration.goodAutomaticNumberOfMines))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    })
                    
                    HStack {
                        Slider(value: Binding(
                                   get: { self.selectedCustomNumberOfMines },
                                   set: { self.selectedCustomNumberOfMines = $0 }
                               ),
                               in: minNumberOfMines ... maxNumberOfMines,
                               step: 1,
                               label: { Text("\(Int(selectedCustomNumberOfMines)) Mines").fontWeight(.medium).controlSize(.small) }
                        )
                            .hidden(shouldUseAutomaticMineCount)
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
    
    
    /// Describes the game as a human-readable string, like:
    /// ```
    /// A (20 × 15) board with 30 mines
    /// ```
    var descriptionOfDifficulty: LocalizedStringKey {
        "A \(selectedGameConfiguration.boardSize.humanReadableDescription) board with \(selectedGameConfiguration.countNumberOfMines) mines"
    }
    
    
    /// Creates a configuration based on the user's currently-selected preferences
    var selectedGameConfiguration: NewGameConfiguration {
        switch DifficultySelection.allCases[orNil: selectedDifficultyIndex] {
        case .none, .custom:
            return NewGameConfiguration(
                boardSize: Board.Size(width: selectedCustomBoardWidth,
                                      height: selectedCustomBoardHeight),
                numberOfMines: .custom(count: UInt(selectedCustomNumberOfMines.clamped(within: minNumberOfMines ... maxNumberOfMines)))
            )
            
        case .predefined(let difficulty):
            return NewGameConfiguration(difficulty: difficulty)
        }
    }
}



extension NewGameSetupView {
    
    /// Updates this setup view to reflect the given configuration
    ///
    /// - Note: The given configuration will _only_ be used to update the view once. It cannot be monitored, nor can it
    ///         be updated to reflect the user's decision. Instead, the `OverallAppState` environment object will be
    ///         mutated once the user is done.
    ///
    /// - Parameter newConfiguration: The configuration which you want to be reflected in this view
    func configuration(_ newConfiguration: NewGameConfiguration) -> Self {
        Self.init(customGameConfiguration: newConfiguration,
                  selectedDifficulty: .inferred(from: newConfiguration))
        
        // I want to do this when the overall app state is first set, but I have no idea how:
//        if let startingDifficulty = newConfiguration.inferredDifficulty(),
//            let startingDifficultyIndex = PredefinedGameDifficulty.allCases.firstIndex(of: startingDifficulty) {
//            newlyConfigured.selectedDifficultyIndex = startingDifficultyIndex
//        }
//        else {
//            newlyConfigured.selectedDifficultyIndex = DifficultySelection.allCases.firstIndex(of: .custom) ?? 0
//        }
//
//        return newlyConfigured
    }
}



private extension NewGameSetupView {
    
    /// The different difficulties that the user can select with this view
    enum DifficultySelection: CaseIterable, Equatable {
        
        /// Use one of the predefined game difficulties
        case predefined(difficulty: PredefinedGameDifficulty)
        
        /// Let the user configure a custom game
        case custom
        
        
        /// The text to show on the screen to the player
        var displayName: LocalizedStringKey {
            switch self {
            case .predefined(let difficulty): return difficulty.displayName
            case .custom: return "Custom"
            }
        }
        
        
        static let allCases: [DifficultySelection] =
            PredefinedGameDifficulty.allCases.map { DifficultySelection.predefined(difficulty: $0) }
                + [.custom]
        
        
        /// Infers the difficulty from the given configuration. If it perfectly matches a predefined configuration,
        /// then `.predefined(difficulty:)` is used. Otherwise, `.custom` is used.
        ///
        /// - Parameter configuration: The configuration from which to infer the difficulty
        /// - Returns: The difficulty which best matches the given configuration
        static func inferred(from configuration: NewGameConfiguration) -> Self {
            configuration
                .inferredDifficulty()
                .map { .predefined(difficulty: $0) }
                ?? .custom
        }
    }
}



struct NewGameSetupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewGameSetupView()
                .previewDisplayName("Default")
            
            
            NewGameSetupView().configuration(.easy)
                .previewDisplayName("Easy")
            
            NewGameSetupView(customGameConfiguration: .intermediate, selectedDifficulty: .predefined(difficulty: .intermediate))
                .previewDisplayName("Intermediate")
            
            NewGameSetupView().configuration(.advanced)
                .previewDisplayName("Advanced")
            
            
            NewGameSetupView().configuration(NewGameConfiguration(boardSize: Board.Size(width: 5, height: 30), numberOfMines: 2))
                .previewDisplayName("Custom")
        }
        .previewLayout(.fixed(width: 400, height: 999))
    }
}
