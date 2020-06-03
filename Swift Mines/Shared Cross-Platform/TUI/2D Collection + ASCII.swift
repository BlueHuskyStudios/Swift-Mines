//
//  2D Collection + ASCII.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-01-10.
//  Copyright © 2020 Ben Leggiero BH-2-PC
//

import Foundation



public extension Sequence where Element: Sequence {
    
    /// Converts a 2D sequence into a string which is an ASCII grid of characters.
    ///
    /// - Note: Since this assumes this is a rectangular sequence (where each subsequence is the same length), then it
    ///         also assumes each sequence is the same length as the first. If any is smaller, then its line in the
    ///         result contains an error character. If any is longer, then its extra characters are omitted from the
    ///         result.
    ///
    /// - Parameters:
    ///   - borderStyle:        The style of the text used as a border for the text grid
    ///   - contentTransformer: Transforms each element into a single ASCII character
    func asAsciiTextGrid(borderStyle: AsciiGridBorderStyle = .default, contentTransformer: (Element.Element) throws -> Character.ASCII) rethrows -> String {
        guard let firstLine = self.first(where: { _ in true }).map(Array.init) else {
            return ""
        }
        
        let firstLineOfCharacters = try firstLine.asLineOfAsciiCharacters(borderStyle: borderStyle, transformer: contentTransformer)
        let eachRowSeparator = borderStyle.rowSeparator(numberOfCells: UInt(firstLine.count), eachCellContentsWidthInCharacters: 1)
        
        
        func topBorder() -> String { borderStyle.topBorder(numberOfCells: UInt(firstLine.count), eachCellContentsWidthInCharacters: 1) }
        
        func bottomBorder() -> String { borderStyle.bottomBorder(numberOfCells: UInt(firstLine.count), eachCellContentsWidthInCharacters: 1) }
        
        func renderLines2ThroughN() throws -> String {
            try self
                .lazy
                .dropFirst()
                .map { try $0.asLineOfAsciiCharacters(borderStyle: borderStyle, transformer: contentTransformer) }
                .joined(separator: "\n" + eachRowSeparator + "\n")
        }
        
        
        return """
            \(topBorder())
            \(firstLineOfCharacters)
            \(eachRowSeparator)
            \(try renderLines2ThroughN())
            \(bottomBorder())
            """
    }
}



// MARK: - ASCII Grid Border Style

public enum AsciiGridBorderStyle {
    /// ```
    /// +---+---+---+
    /// | 1 | 2 | 3 |
    /// +---+---+---+
    /// | 4 | 5 | 6 |
    /// +---+---+---+
    /// ```
    case plussesAndDashes
    
    /// ```
    /// 1  2  3
    /// 4  5  6
    /// ```
    case none
}


// MARK: Functionality

public extension AsciiGridBorderStyle {
    
    /// The border along the top of a grid
    ///
    /// - Parameters:
    ///   - numberOfCells:                     How many cells are in the top row
    ///   - eachCellContentsWidthInCharacters: The number of characters which occupy each cell's content
    func topBorder(numberOfCells: UInt, eachCellContentsWidthInCharacters: UInt) -> String {
        return horizLine(
            numberOfCells: numberOfCells,
            eachCellContentsWidthInCharacters: eachCellContentsWidthInCharacters,
            left: topLeftCorner,
            edge: topEdge,
            intersection: topIntersection,
            right: topRightCorner)
    }
    
    
    /// The border along the bottom of a grid
    ///
    /// - Parameters:
    ///   - numberOfCells:                     How many cells are in the top row
    ///   - eachCellContentsWidthInCharacters: The number of characters which occupy each cell's content
    func rowSeparator(numberOfCells: UInt, eachCellContentsWidthInCharacters: UInt) -> String {
        return horizLine(
            numberOfCells: numberOfCells,
            eachCellContentsWidthInCharacters: eachCellContentsWidthInCharacters,
            left: rowSeparatorLeftIntersection,
            edge: rowSeparatorMiddleEdge,
            intersection: rowSeparatorIntersection,
            right: rowSeparatorRightIntersection)
    }
    
    
    /// The border along the bottom of a grid
    ///
    /// - Parameters:
    ///   - numberOfCells:                     How many cells are in the top row
    ///   - eachCellContentsWidthInCharacters: The number of characters which occupy each cell's content
    func bottomBorder(numberOfCells: UInt, eachCellContentsWidthInCharacters: UInt) -> String {
        return horizLine(
            numberOfCells: numberOfCells,
            eachCellContentsWidthInCharacters: eachCellContentsWidthInCharacters,
            left: bottomLeftCorner,
            edge: bottomEdge,
            intersection: bottomIntersection,
            right: bottomRightCorner)
    }
    
    
    private func horizLine(
        numberOfCells: UInt,
        eachCellContentsWidthInCharacters: UInt,
        left: String,
        edge: String,
        intersection: String,
        right: String
    ) -> String {
        let eachCellEdgeWidth = Int(eachCellContentsWidthInCharacters + 2) // plus two for the number of spaces which pad the
        let eachLine = String(repeating: edge, count: eachCellEdgeWidth)
        
        return left
            + (1...numberOfCells)
                .lazy
                .map { _ in eachLine }
                .joined(separator: intersection)
            + right
    }
}



private extension AsciiGridBorderStyle {
    
    var lineStartWithPadding: String {
        switch self {
        case .plussesAndDashes: return "\(lineStartWithoutPadding) "
        case .none: return ""
        }
    }
    
    
    var lineStartWithoutPadding: String {
        switch self {
        case .plussesAndDashes: return "|"
        case .none: return ""
        }
    }
    
    
    var cellSeparatorWithPadding: String {
        return " \(cellSeparatorWithoutPadding) "
    }
    
    
    var cellSeparatorWithoutPadding: String {
        switch self {
        case .plussesAndDashes: return "|"
        case .none: return ""
        }
    }
    
    
    var lineEndWithPadding: String {
        switch self {
        case .plussesAndDashes: return " \(lineStartWithoutPadding)"
        case .none: return ""
        }
    }
    
    
    var lineEndWithoutPadding: String {
        switch self {
        case .plussesAndDashes: return "|"
        case .none: return ""
        }
    }
    
    
    // MARK: Top border
    
    var topLeftCorner: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    var topEdge: String {
        switch self {
        case .plussesAndDashes: return "-"
        case .none: return ""
        }
    }
    
    
    var topIntersection: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    var topRightCorner: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    // MARK: Row separtor
    
    var rowSeparatorLeftIntersection: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    var rowSeparatorMiddleEdge: String {
        switch self {
        case .plussesAndDashes: return "-"
        case .none: return ""
        }
    }
    
    
    var rowSeparatorIntersection: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    var rowSeparatorRightIntersection: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    // MARK: Bottom border
    
    var bottomLeftCorner: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    var bottomEdge: String {
        switch self {
        case .plussesAndDashes: return "-"
        case .none: return ""
        }
    }
    
    
    var bottomIntersection: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
    
    
    var bottomRightCorner: String {
        switch self {
        case .plussesAndDashes: return "+"
        case .none: return ""
        }
    }
}


// MARK: Public constants

public extension AsciiGridBorderStyle {
    static let `default` = plussesAndDashes
}



// MARK: -

public extension Character {
    typealias ASCII = UInt8
    
    
    init(ascii: ASCII) {
        self.init(Unicode.Scalar(ascii))
    }
}



public extension Character.ASCII {
    var isPrintableAsciiCharacter: Bool {
        switch self {
        case 0...31,    // Control Characters
             128...255: // Above ASCII range
            return false
            
        case 32...127:
            return true
            
        default:
            fatalError("Swift why did you let a UInt8 switch go past 0...255?")
        }
    }
}



// MARK: - File-Private Conveniences

private extension Sequence {
    
    func asLineOfAsciiCharacters(borderStyle: AsciiGridBorderStyle, transformer: (Element) throws -> Character.ASCII) rethrows -> String {
        return borderStyle.lineStartWithPadding
            + (try self
                .lazy
                .asAsciiCharacters(transformer: transformer)
                .map(Character.init(ascii:))
                .map(String.init)
                .joined(separator: borderStyle.cellSeparatorWithPadding))
            + borderStyle.lineEndWithPadding
    }
    
    
    @inline(__always)
    func asAsciiCharacters(transformer: (Element) throws -> Character.ASCII) rethrows -> [Character.ASCII] {
        return try map(transformer)
    }
}
