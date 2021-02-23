//
//  AppDelegate.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import SwiftUI
import RectangleTools
import SafePointer
import Combine
import SafeCollectionAccess



/// The sink we currently use to absorb changes to the current app screen
private var currentScreenSink: AnyCancellable? = nil



/// The main entry point for Swift Mines on macOS. This currently handles all the AppKit-specific behavior.
@main
struct SwiftMines {
    
//    @NSApplicationDelegateAdaptor
//    private var appDelegate: __cocoa__AppDelegate
    
//    fileprivate let menuBarSelectionNotificationListener = NotificationCenter.default
//        .publisher(for: .menuBarSelection)
//        .map(\.object)
//        .compactMap { $0 as? MenuItem }
    
    /// The state of the app, which is used for updating the board, the current screen, etc.
    @State
    fileprivate var overallAppState = OverallAppState(game: .basicNewGame())
    
    
    init() {
        __dirtyHack__setUpMenuBar()
    }
}



extension SwiftMines: App {
    
    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            ContentView(overallAppState: $overallAppState)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Source Code", action: didSelectSourceCodeMenuItem)
            }

            CommandGroup(replacing: .newItem) {
                Button("New Game", action: didSelectNewGameMenuItem)
                    .keyboardShortcut("N")
            }
        }
    }
}



private extension SwiftMines {
    enum MenuItem: Int {
        case newGame = 1
    }
}



private extension SwiftMines {
    
    func __dirtyHack__setUpMenuBar() {
        
        let gameMenuTitle = NSLocalizedString("command.menu.game.title", comment: "Game")
        var oldFileMenuItem: NSMenuItem? { NSApp?.mainMenu?.items[orNil: 1] }
        
        DispatchQueue.main.async {
            oldFileMenuItem?.title = gameMenuTitle
            oldFileMenuItem?.submenu?.title = gameMenuTitle
        }
    }
    
    
    func userDidSelectMenuItem(_ menuItem: MenuItem) {
        switch menuItem {
        case .newGame: didSelectNewGameMenuItem()
        }
    }
    
//    /// Returns the currently-appropriate method selectors for the game menu items
//    ///
//    /// - Parameter enabled: Whether the menu items should be enabled
//    func gameMenuSelectors(enabled: Bool) -> GameMenuSelectors? {
//        return enabled
//            ? GameMenuSelectors(newGame: #selector(AppDelegate.didSelectNewGameMenuItem),
//                                restart: #selector(AppDelegate.didSelectRestartMenuItem))
//            : nil
//    }
    
    
    /// The user selected the "Source Code" menu item in the "Swift Mines" menu
    func didSelectSourceCodeMenuItem() {
        NSWorkspace.shared.open(.repo)
    }
    
    
    /// The user selected the "New" menu item in the "Game" menu
    func didSelectNewGameMenuItem() {
        overallAppState.currentScreen = .newGameSetup
    }
    
    
//    /// The user selected the "Restart" menu item in the "Game" menu
//    @objc(didSelectRestartMenuItem:)
//    @IBAction func didSelectRestartMenuItem(sender: NSMenuItem) {
//        overallAppState.game.startNewGame()
//    }
//    
//    
//    /// The user selected the "Feedback" menu item in the "Help" menu
//    @objc(didSelectFeedbackMenuItem:)
//    @IBAction func didSelectFeedbackMenuItem(sender: NSMenuItem) {
//        NSWorkspace.shared.open(.feedback)
//    }
//    
//    
//    /// The user selected the "Swift Mines Help" menu item in the "Help" menu
//    @objc(showHelp:)
//    @IBAction func showHelp(sender: NSMenuItem) {
//        NSWorkspace.shared.open(.help)
//    }
//    
//    
//    
//    /// All selectors corresponding to menu items in the "Game" menu
//    typealias GameMenuSelectors = (newGame: Selector, restart: Selector)
}



//// MARK: - Cocoa shim
//
//@objc(AppDelegate)
//internal class __cocoa__AppDelegate: NSObject, NSApplicationDelegate {
//
//    func applicationDidFinishLaunching(_: Notification) {
//        NSApp.delegate = self
//        NSNib(nibNamed: "MenuBar", bundle: .main)?
//            .instantiate(withOwner: NSApp, topLevelObjects: nil)
//    }
//
//    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool { true }
//
//    @objc(didSelectMenuItem:)
//    @IBAction func didSelectMenuItem(_ sender: NSMenuItem) {
//        guard let menuItem = SwiftMines.MenuItem(rawValue: sender.tag) else {
//            assertionFailure()
//            return
//        }
//
//        NotificationCenter.default.post(name: .menuBarSelection, object: menuItem)
//    }
//}
//
//
//
//private extension Notification.Name {
//    static let menuBarSelection = Self("\(Bundle.main.bundleIdentifier!).menuBarSelection")
//}
