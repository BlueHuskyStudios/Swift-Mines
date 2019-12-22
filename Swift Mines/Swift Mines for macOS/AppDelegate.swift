//
//  AppDelegate.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa
import SwiftUI
import RectangleTools



@NSApplicationMain
class AppDelegate: NSObject {

    var window: NSWindow!
}



extension AppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard !CommandLine.arguments.contains("doNotRunApp") else {
            // This argument is passed by the testing suite
            return
        }
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(
            game: Game.new(size: UIntSize(width: 20, height: 20),
                           totalNumberOfMines: (40))
        )

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.title = "Swift Mines"
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool { true }
}
