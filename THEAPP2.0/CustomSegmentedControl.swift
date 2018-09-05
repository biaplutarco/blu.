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
    let highlightColor = UIColor.white
    var fontSize: CGFloat?
    
    required init(items: [Any]) {
        super.init(items: items)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        for view in sortedViews {
            view.layer.cornerRadius = 10
            
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let height = getHeightSize(forWidth: UIScreen.main.nativeBounds.width)
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        self.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        self.backgroundColor = UIColor(named: "MainColor")
        self.layer.borderWidth = 6
        
        
        changeSelectedIndex(to: currentIndex)
        self.tintColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        fontSize = getFontSize(forWidth: UIScreen.main.nativeBounds.width)
        
        let selectedAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize!, weight: .semibold)]
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
        let unselectedAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize!, weight: .bold)]
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
        
    }
    
    func changeSelectedIndex(to newIndex: Int) {
        sortedViews[currentIndex].backgroundColor = UIColor.clear
        currentIndex = newIndex
        self.selectedSegmentIndex = UISegmentedControlNoSegment
        sortedViews[currentIndex].backgroundColor = .white
        self.selectedSegmentIndex = currentIndex
    }
    
    func getFontSize(forWidth width: CGFloat) -> CGFloat {
        var size: CGFloat
        if width == 640 {
            size = 14.0
        } else {
            size = 18.0
        }
        return size
    }
    
    func getHeightSize(forWidth width: CGFloat) -> CGFloat {
        var size: CGFloat
        if width == 640 {
            size = 32
        } else {
            size = 42
        }
        return size
    }
}
