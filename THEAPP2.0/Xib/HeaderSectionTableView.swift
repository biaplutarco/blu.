//
//  HeaderSectionTableView.swift
//  TipsScreen
//
//  Created by Ada 2018 on 03/09/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class HeaderSectionTableView: UITableViewHeaderFooterView {
    
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roomLabel.text = "Kitchen"
        
        cardView.backgroundColor = UIColor(named: "MainColor")
        cardView.layer.cornerRadius = 5
        cardView.clipsToBounds = true
    }
}
