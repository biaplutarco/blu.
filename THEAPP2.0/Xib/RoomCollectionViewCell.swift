//
//  RoomCollectionViewCell.swift
//  LocalNotification
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class RoomCollectionViewCell: UICollectionViewCell {

    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var tasksRoom: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var background: UIView!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                roomLabel.textColor = UIColor(named: "MainColor")
                iconImageView.tintColor = UIColor(named: "MainColor")
                tasksRoom.textColor = .darkGray
            }
            else
            {
                roomLabel.textColor = .lightGray
                iconImageView.tintColor = .lightGray
                tasksRoom.textColor = .lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        background.layer.cornerRadius = 5
        background.layer.shadowOffset = CGSize(width: 0, height: 2)
        background.layer.shadowOpacity = 0.5
        background.layer.shadowRadius = 8
        
        self.clipsToBounds = false
        
        iconImageView.tintColor = .lightGray
    }
    
    func setIcon(image: UIImage) {
        
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        
        iconImageView.image = tintedImage
        
    }

}
