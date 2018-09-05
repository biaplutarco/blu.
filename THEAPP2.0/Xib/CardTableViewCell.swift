//
//  CardTableViewCell.swift
//  TipsScreen
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemTimeLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cardView.layer.cornerRadius = 5
        cardView.clipsToBounds = false
        
        cardView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 8
        
    }

}
