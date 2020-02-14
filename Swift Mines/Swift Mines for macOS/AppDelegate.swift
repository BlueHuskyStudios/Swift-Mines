//
//  AppDelegate.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import Cocoa
import SwiftUI
import RectangleTools
import SafePointer
import Combine



/// The sink we currently use to absorb changes to the current app screen
private var currentScreenSink: AnyCancellable? = nil



/// The main entry point for Swift Mines on macOS. This currently handles all the AppKit-specific behavior.
@NSApplicationMain
class AppDelegate: NSObject {

    /// The primary window for Swift Mines on macOS
    var window: NSWindow!
    
    /// The "Game" menu item
    @IBOutlet weak var gameMenu: NSMenu!
    
    /// The "New Game" menu item
    @IBOutlet weak var newGameMenuItem: NSMenuItem!
    
    /// The "Restart" menu item
    @IBOutlet weak var restartGameMenuItem: NSMenuItem!
    
    /// The state of the app, which is used for updating the board, the current screen, etc.
    var overallAppState = OverallAppState(
        game: Game.new(size: Board.Size(width: 10, height: 10))
    )
}



extension AppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard !CommandLine.arguments.contains("doNotRunApp") else {
            // This argument is passed by the testing suite
            return
        }
        
        
        currentScreenSink = overallAppState.currentScreenPublisher()
            .map { $0 == .game }
            .map(gameMenuSelectors)
            .sink {
                self.newGameMenuItem.action = $0?.newGame
                self.restartGameMenuItem.action = $0?.restart
            }
        
        
        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.title = "Swift Mines"
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: ContentView().environmentObject(overallAppState))
        window.makeKeyAndOrderFront(nil)
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool { true }
}



private extension AppDelegate {
    
    /// Returns the currently-appropriate method selectors for the game menu items
    ///
    /// - Parameter enabled: Whether the menu items should be enabled
    func gameMenuSelectors(enabled: Bool) -> GameMenuSelectors? {
        return enabled
            ? GameMenuSelectors(newGame: #selector(AppDelegate.didSelectNewGameMenuItem),
                                restart: #selector(AppDelegate.didSelectRestartMenuItem))
            : nil
    }
    
    
    /// The user selected the "Source Code" menu item in the "Swift Mines" menu
    @IBAction func didSelectSourceCodeMenuItem(sender: NSMenuItem) {
        NSWorkspace.shared.open(.repo)
    }
    
    
    /// The user selected the "New" menu item in the "Game" menu
    @IBAction func didSelectNewGameMenuItem(sender: NSMenuItem) {
        overallAppState.currentScreen = .newGameSetup
    }
    
    
    /// The user selected the "Restart" menu item in the "Game" menu
    @IBAction func didSelectRestartMenuItem(sender: NSMenuItem) {
        overallAppState.game.startNewGame()
    }
    
    
    /// The user selected the "Feedback" menu item in the "Help" menu
    @IBAction func didSelectFeedbackMenuItem(sender: NSMenuItem) {
        NSWorkspace.shared.open(.feedback)
    }
    
    
    /// The user selected the "Swift Mines Help" menu item in the "Help" menu
    @IBAction func showHelp(sender: NSMenuItem) {
        NSWorkspace.shared.open(.help)
    }
    
    
    
    /// All selectors corresponding to menu items in the "Game" menu
    typealias GameMenuSelectors = (newGame: Selector, restart: Selector)
}
