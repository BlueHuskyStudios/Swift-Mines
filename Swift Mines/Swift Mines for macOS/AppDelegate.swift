//
//  AppDelegate.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero BH-1-PS
//

import Cocoa
import SwiftUI
import RectangleTools
import SafePointer



@NSApplicationMain
class AppDelegate: NSObject {

    var window: NSWindow!
    
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
    
    @IBAction func didSelectNewGameMenuItem(_ sender: NSMenuItem) {
        overallAppState.currentScreen = .newGameSetup
    }
}
