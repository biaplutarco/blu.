//
//  AddItemCollectionViewCellTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
@testable import THEAPP2_0

class AddItemCollectionViewCellTests: XCTestCase {
    
    var cell: AddItemCollectionViewCell?
    
    override func setUp() {
        super.setUp()
    
        let bundle = Bundle(for: self.classForCoder)
        let xib = bundle.loadNibNamed("AddItemCollectionViewCell", owner: nil, options: nil)
        cell = xib?.first as? AddItemCollectionViewCell
        
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func test_isSelected_true() {
        cell?.isSelected = true
        XCTAssertEqual(cell?.nameRoom.textColor, UIColor(named: "MainColor"))
        XCTAssertEqual(cell?.imageRoom.tintColor, UIColor(named: "MainColor"))
    }
    
    func test_isSelected_false() {
        cell?.isSelected = false
        XCTAssertEqual(cell?.nameRoom.textColor, UIColor.lightGray)
        XCTAssertEqual(cell?.imageRoom.tintColor, UIColor.lightGray)
    }
    
    func test_setIcon() {
        
        let image = UIImage(named: "Bedroom")
        
        cell?.setIcon(image: image!)
        
        XCTAssertEqual(UIImagePNGRepresentation((cell?.imageRoom.image)!), UIImagePNGRepresentation(image!))
        XCTAssertEqual(cell?.imageRoom.image?.renderingMode, UIImageRenderingMode.alwaysTemplate)
        
    }
    
}
