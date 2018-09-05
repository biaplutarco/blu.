//
//  HouseCategory.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

enum HouseCategory: String {
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case bedroom = "Bedroom"
    case bathroom = "Bathroom"
    
    static var allCases: [HouseCategory] = [.livingRoom, .kitchen, .bedroom, .bathroom]
}
