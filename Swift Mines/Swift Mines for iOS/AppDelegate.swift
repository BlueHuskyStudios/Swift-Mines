//
//  AppDelegate.swift
//  Swift Mines for iOS
//
//  Created by Ben Leggiero on 2020-05-24.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import UIKit
import SimpleLogging



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    override init() {
        super.init()
        
        do {
            let errorLogPath = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
                .appendingPathComponent(Bundle.main.bundleIdentifier ?? "Swift Mines")
                .appendingPathComponent("Logs")
                .appendingPathComponent("Errors.log")
                .path
            
            LogManager.defaultChannels.append(
                try LogChannel(name: "Errors",
                               location: .file(path: errorLogPath),
                               lowestAllowedSeverity: .error)
            )
        }
        catch {
            assertionFailure("Could not set up logging: \(error)")
            print(error)
        }
    }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

