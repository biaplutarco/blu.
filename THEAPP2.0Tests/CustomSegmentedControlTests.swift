//
//  CustomSegmentedControlTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
@testable import THEAPP2_0

class CustomSegmentedControlTests: XCTestCase {
    
    let items = ["Today", "This Week", "This Month", "After"]
    var segmentedControl: CustomSegmentedControl?
    
    override func setUp() {
        super.setUp()
        
        segmentedControl = CustomSegmentedControl(items: items)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_getFontSize_SE() {
        let fontSize = segmentedControl?.getFontSize(forWidth: 640)
        XCTAssertEqual(fontSize, 14.0)
    }
    
    func test_getFontSize_SIX() {
        let fontSize = segmentedControl?.getFontSize(forWidth: 1080)
        XCTAssertEqual(fontSize, 18.0)
    }
    
    func test_getHeightSize_SE() {
        let heightSize = segmentedControl?.getHeightSize(forWidth: 640)
        XCTAssertEqual(heightSize, 32.0)
    }
    
    func test_getHeightSize_SIX() {
        let heightSize = segmentedControl?.getHeightSize(forWidth: 1080)
        XCTAssertEqual(heightSize, 42.0)
    }
    
}
