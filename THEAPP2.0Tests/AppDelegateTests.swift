//
//  AppDelegateTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 05/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
@testable import THEAPP2_0

class AppDelegateTests: XCTestCase {
    
    var delegate: AppDelegate?
    override func setUp() {
        super.setUp()
        delegate = AppDelegate()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func test_shortcutAddItem() {
//        let firstShortcut = UIApplication.shared.shortcutItems?.first
//        delegate?.application(UIApplication.shared, performActionFor: firstShortcut!, completionHandler: (Bool) -> Void)
//        XCTAssertEqual(delegate?.window?.rootViewController, AddItemViewController())
//    }
}
