//
//  TaskTableViewCell.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var labelLeft: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var item: Item? {
        didSet {
            taskName.text = item?.name
            setProgress(initialDate: (item?.initialDate!)!, finalDate: (item?.finalDate!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressBar.progressViewStyle = .default
        progressBar.trackTintColor = UIColor(named: "TrackTint")
        progressBar.progressTintColor = UIColor(named: "ProgressTint")
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 4)
        progressBar.layer.cornerRadius = 8
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 8
        progressBar.subviews[1].clipsToBounds = true
        
        
        cardView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 8
        cardView.clipsToBounds = false
        
        labelLeft.isHidden = false
        timeLeft.isHidden = false
        checkBtn.isHidden = true
        
        let icon = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
        checkBtn.setImage(icon, for: .normal)
        
        if let done = item?.isDone {
            checkBtn.tintColor = done ? UIColor(named: "CheckColor") : .lightGray
        } else {
            checkBtn.tintColor = .lightGray
        }
        
    }
    
    @IBAction func checked(_ sender: Any) {
        guard let item = self.item else {
            return
        }
        item.isDone = !item.isDone
        do {
            try DBManager.shared.save()
        } catch {
            item.isDone = !item.isDone
        }
        checkBtn.tintColor = item.isDone ? UIColor(named: "CheckColor") : .lightGray
        
        //TEM QUE TER UM ALERTA
    }
    
    func timeDisplay(forAmount amount: Int, onUnit unit: String) -> String {
        return "\(amount) " + unit + ((amount <= 1) ? "" : "s")
    }

    
    func timeDisplay(forAmountOfDays amount: Int) -> String {
        
        let result: String
        
        if amount < 7 {
            result = timeDisplay(forAmount: amount, onUnit: "day")
        } else if amount < 31 {
            result =  timeDisplay(forAmount: amount / 7, onUnit: "week")
        } else if amount < 365 {
            result = timeDisplay(forAmount: amount / 31, onUnit: "month")
        } else {
            result = timeDisplay(forAmount: amount / 365, onUnit: "year")
        }
        
        return result
    }
    
    func setProgress(initialDate: Date, finalDate: Date) {
        if initialDate == finalDate {
            progressBar.progress = 0
            return
        }
        
        let total = Calendar.current.dateComponents([.second], from: initialDate, to: finalDate)
        let passed = Calendar.current.dateComponents([.second], from: initialDate, to: Date())
        let left = Calendar.current.dateComponents([.day], from: Date(), to: finalDate)
        
        guard let secondsPassed = passed.second, let daysLeft = left.day, let secondsTotal = total.second else {
            return
        }
        
        let progress = Float(secondsPassed)/Float(secondsTotal)
        
        if (progress.isNaN) {
            progressBar.progress = 0
            return
        }
        
        progressBar.progress = progress
        
        if Int(progress) == 1 {
            labelLeft.isHidden = true
            timeLeft.isHidden = true
            checkBtn.isHidden = false
        } else {
            labelLeft.isHidden = false
            timeLeft.isHidden = false
            checkBtn.isHidden = true
            if progress <= 0 {
                timeLeft.text = "Waiting to"
                labelLeft.text = "begin"
            } else if progress < 1 {
                timeLeft.text = timeDisplay(forAmountOfDays: daysLeft)
                labelLeft.text = "left"
            } else {
                timeLeft.text = timeDisplay(forAmountOfDays: -daysLeft)
                labelLeft.text = "late"
            }
        }
        
    }
    
    
}

