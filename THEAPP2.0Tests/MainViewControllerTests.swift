//
//  MainViewControllerTests.swift
//  THEAPP2.0Tests
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
@testable import THEAPP2_0

class MainViewControllerTests: XCTestCase {
    
    var viewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "mainController") as! MainViewController
        _ = viewController.view
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_valueChanged() {
        
        viewController.valueChanged(viewController.segmentControl)
        
    }

    
}
