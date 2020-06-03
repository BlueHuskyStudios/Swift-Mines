//
//  Assertion Debugging.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation



/// Allows you to return a backup value for production, and also throw an assertion while debugging
///
/// - Parameters:
///   - message:     The message to log with the assertion failure
///   - backupValue: The value to return in production
public func assertionFailure<Backup>(_ message: @autoclosure () -> String = String(), backupValue: @autoclosure () -> Backup) -> Backup {
    assertionFailure(message())
    return backupValue()
}
