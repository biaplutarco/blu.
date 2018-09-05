//
//  RoomCollectionViewCellTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 03/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
@testable import THEAPP2_0

class RoomCollectionViewCellTests: XCTestCase {
    
    var cell: RoomCollectionViewCell?
    
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle(for: self.classForCoder)
        let xib = bundle.loadNibNamed("RoomCollectionViewCell", owner: nil, options: nil)
        cell = xib?.first as? RoomCollectionViewCell
        
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func test_isSelected_true(){
        cell?.isSelected = true
        XCTAssertEqual(cell?.roomLabel.textColor, UIColor(named: "MainColor"))
        XCTAssertEqual(cell?.iconImageView.tintColor, UIColor(named: "MainColor"))
        XCTAssertEqual(cell?.tasksRoom.textColor, UIColor.darkGray)
    }
    
    func test_isSelected_false(){
        cell?.isSelected = false
        XCTAssertEqual(cell?.roomLabel.textColor, UIColor.lightGray)
        XCTAssertEqual(cell?.iconImageView.tintColor, UIColor.lightGray)
        XCTAssertEqual(cell?.tasksRoom.textColor, UIColor.lightGray)
    }
    
}
