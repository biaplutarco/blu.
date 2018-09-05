//
//  ItemExtension.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

extension Item {
    public override var description: String {
        get {
            guard let name = self.name, let category = self.category, let initialDate = self.initialDate, let finalDate = self.finalDate else {
                return ""
            }
            return "\(name)-\(category)-\(initialDate)-\(finalDate)"
        }
    }
}
