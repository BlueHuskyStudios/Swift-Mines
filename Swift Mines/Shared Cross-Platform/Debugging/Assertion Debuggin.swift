//
//  Assertion Debuggin.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2019-12-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public func assertionFailure<Backup>(_ message: String, backupValue: @autoclosure () -> Backup) -> Backup {
    assertionFailure(message)
    return backupValue()
}
