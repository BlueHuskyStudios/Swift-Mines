//
//  URL Constants.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-02-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation



public extension URL {
    
    /// The URL for the GitHub repo for this app
    static let repo = URL(string: "https://github.com/BenLeggiero/Swift-Mines")
        ?? URL(fileURLWithPath: "").also { assertionFailure("The repo URL the developer provided was invalid") }
    
    /// The URL for providing feedback about Swift Mines
    static let feedback = help.appendingPathComponent("new")
    
    /// The URL for seeking help about Swift Mines
    static let help = repo.appendingPathComponent("issues")
}
