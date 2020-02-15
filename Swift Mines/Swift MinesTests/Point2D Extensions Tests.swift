//
//  Point2D Extensions Tests.swift
//  Swift MinesTests
//
//  Created by Ben Leggiero on 2019-12-19.
//  Copyright © 2020 Ben Leggiero BH-1-PS
//

import XCTest
import RectangleTools
@testable import Swift_Mines



class Point2D_Extensions_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testIsTouching__UIntPoint__2_2() {
        let point_2_2 = UIntPoint(x: 2, y: 2)
        
        XCTAssertTrue(point_2_2.isTouching(point_2_2))
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 2, y: 2)))
        XCTAssertTrue(point_2_2.isTouching(point_2_2, inclusive: true))
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 2, y: 2), inclusive: true))
        XCTAssertFalse(point_2_2.isTouching(point_2_2, inclusive: false))
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 2, y: 2), inclusive: false))
        
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 2, y: 3))) // ↑1
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 3, y: 3))) // ↗︎1
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 3, y: 2))) // →1
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 3, y: 1))) // ↘︎1
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 2, y: 1))) // ↓1
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 1, y: 1))) // ↙︎1
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 1, y: 2))) // ←1
        XCTAssertTrue(point_2_2.isTouching(UIntPoint(x: 1, y: 3))) // ↖︎1
        
        
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 2, y: 4))) // ↑2
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 4, y: 4))) // ↗︎2
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 4, y: 2))) // →2
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 4, y: 0))) // ↘︎2
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 2, y: 0))) // ↓2
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 0, y: 0))) // ↙︎2
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 0, y: 2))) // ←2
        XCTAssertFalse(point_2_2.isTouching(UIntPoint(x: 0, y: 4))) // ↖︎2
    }
    

    func testIsTouching__UIntPoint__0_0() {
        let point_0_0 = UIntPoint(x: 0, y: 0)
        
        XCTAssertTrue(point_0_0.isTouching(point_0_0))
        XCTAssertTrue(point_0_0.isTouching(UIntPoint(x: 0, y: 0)))
        XCTAssertTrue(point_0_0.isTouching(point_0_0, inclusive: true))
        XCTAssertTrue(point_0_0.isTouching(UIntPoint(x: 0, y: 0), inclusive: true))
        XCTAssertFalse(point_0_0.isTouching(point_0_0, inclusive: false))
        XCTAssertFalse(point_0_0.isTouching(UIntPoint(x: 0, y: 0), inclusive: false))
        
        XCTAssertTrue(point_0_0.isTouching(UIntPoint(x:  0, y:  1))) // ↑1
        XCTAssertTrue(point_0_0.isTouching(UIntPoint(x:  1, y:  1))) // ↗︎1
        XCTAssertTrue(point_0_0.isTouching(UIntPoint(x:  1, y:  0))) // →1
        // These should not compile:
        // XCTAssertTrue(point_0_0.isTouching(UIntPoint(x:  1, y: -1))) // ↘︎1
        // XCTAssertTrue(point_0_0.isTouching(UIntPoint(x:  0, y: -1))) // ↓1
        // XCTAssertTrue(point_0_0.isTouching(UIntPoint(x: -1, y: -1))) // ↙︎1
        // XCTAssertTrue(point_0_0.isTouching(UIntPoint(x: -1, y:  0))) // ←1
        // XCTAssertTrue(point_0_0.isTouching(UIntPoint(x: -1, y:  1))) // ↖︎1
        
        
        XCTAssertFalse(point_0_0.isTouching(UIntPoint(x:  0, y:  2))) // ↑2
        XCTAssertFalse(point_0_0.isTouching(UIntPoint(x:  2, y:  2))) // ↗︎2
        XCTAssertFalse(point_0_0.isTouching(UIntPoint(x:  2, y:  0))) // →2
        // These should not compile
        // XCTAssertFalse(point_0_0.isTouching(UIntPoint(x:  2, y: -2))) // ↘︎2
        // XCTAssertFalse(point_0_0.isTouching(UIntPoint(x:  0, y: -2))) // ↓2
        // XCTAssertFalse(point_0_0.isTouching(UIntPoint(x: -2, y: -2))) // ↙︎2
        // XCTAssertFalse(point_0_0.isTouching(UIntPoint(x: -2, y:  0))) // ←2
        // XCTAssertFalse(point_0_0.isTouching(UIntPoint(x: -2, y:  2))) // ↖︎2
    }
}
