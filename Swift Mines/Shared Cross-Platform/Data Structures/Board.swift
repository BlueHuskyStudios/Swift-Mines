//
//  Board.swift
//  Swift Mines
//
//  Created by Ben Leggiero on 2019-12-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import RectangleTools



/// A game board for Mines
public struct Board {
    
    /// The content of the game board: A grid of unannotated Mines board squares
    var content: [[BoardSquare]]
}



public extension Board {
    
    /// The number of cells wide and tall
    var size: UIntSize {
        UIntSize(width: UInt(content[0].count), height: UInt(content.count))
    }
    
    
    /// <#Description#>
    /// - Parameter baseStyle: <#baseStyle description#>
    func annotated(baseStyle: Style) -> Annotated {
        <#function body#>
    }
}



// MARK: - Annotated

public extension Board {
    
    struct Annotated {
        let content: [[BoardSquare.Annotated]]
        let style: Style
    }
}



// MARK: - Convenience initializers

public extension Board {
    
    static func random(size: UIntSize) -> Board {
        return Board(content: size.map2D { _ in
            BoardSquare.random()
        })
    }
}
