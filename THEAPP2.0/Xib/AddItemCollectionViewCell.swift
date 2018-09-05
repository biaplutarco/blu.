//
//  AddItemCollectionViewCell.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class AddItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameRoom: UILabel!
    @IBOutlet weak var imageRoom: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                nameRoom.textColor = UIColor(named: "MainColor")
                imageRoom.tintColor = UIColor(named: "MainColor")
            }
            else
            {
                nameRoom.textColor = .lightGray
                imageRoom.tintColor = .lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 8
        
        self.clipsToBounds = false
        
        imageRoom.tintColor = .lightGray
        nameRoom.textColor = .lightGray
    }
    
    func setIcon(image: UIImage) {
        
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        
        imageRoom.image = tintedImage
        
    }

}
