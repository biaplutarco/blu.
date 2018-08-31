//
//  CustomSegmentedControl.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    var sortedViews: [UIView]!
    var currentIndex: Int = 0
    let highlightColor = UIColor.darkGray
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        for view in sortedViews {
            view.layer.cornerRadius = 5
        }
        changeSelectedIndex(to: currentIndex)
        
        
        
        //self.backgroundColor = #colorLiteral(red: 0, green: 0.7254901961, blue: 0.7098039216, alpha: 1)
        self.tintColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        let unselectedAttributes = [NSAttributedStringKey.foregroundColor: highlightColor,
                                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
    }
    
    func changeSelectedIndex(to newIndex: Int) {
        sortedViews[currentIndex].backgroundColor = UIColor.clear
        currentIndex = newIndex
        self.selectedSegmentIndex = UISegmentedControlNoSegment
        sortedViews[currentIndex].backgroundColor = #colorLiteral(red: 0, green: 0.7254901961, blue: 0.7098039216, alpha: 1)
    }
}
