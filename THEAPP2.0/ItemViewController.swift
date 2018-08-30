//
//  ItemViewController.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import UserNotifications

class ItemViewController: UIViewController {
    
    @IBOutlet weak var taskSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var initialDateTextField: UITextField!
    @IBOutlet weak var timeFrameTextField: UITextField!
    @IBOutlet weak var timeUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var notificationTimeTextField: UITextField!
    
    var pickerView = UIPickerView()
    var datePickerDate = UIDatePicker()
    var datePickerTime = UIDatePicker()
    var timeValue = Int()
    var timeFrame: TimeInterval {
        get {
            switch timeUnitSegmentedControl.selectedSegmentIndex {
                case 0:
                    return Double(timeValue * 86400)
                case 1:
                    return Double(timeValue * 604800)
                case 2:
                    return Double(timeValue * 2592000)
                case 3:
                    return Double(timeValue * 31104000)
                default:
                    return 0
            }
        }
    }
    var taskType: TaskType = .change
    var category: HouseCategory?
    
    var accessoryToolbar: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTapped(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white
            return accessoryToolbar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerDate.datePickerMode = .date
        initialDateTextField.inputView = datePickerDate
        initialDateTextField.inputAccessoryView = accessoryToolbar
        timeFrameTextField.delegate = self
        datePickerTime.datePickerMode = .time
        notificationTimeTextField.inputView = datePickerTime
        notificationTimeTextField.inputAccessoryView = accessoryToolbar
    }
    
    @IBAction func saveItem(_ sender: Any) {
        guard let name = nameTextField.text else {
            
            return
        }
        guard let houseCategory = category else {
            
            return
        }
        let calendar = Calendar.current
        let time = TimeInterval(calendar.component(.hour, from: datePickerTime.date) * 3600 + calendar.component(.minute, from: datePickerTime.date) * 60)
        let initialDate = datePickerDate.date.addingTimeInterval(time)
        let finalDate = initialDate.addingTimeInterval(timeFrame)
        DBManager.insertItem(name: name, initialDate: initialDate, finalDate: finalDate, category: houseCategory)
        registerNotification(name: nameTextField.text!, expirationDate: finalDate)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func valueChanged(_ sender: CustomSegmentedControl) {
        sender.changeSelectedIndex(to: sender.selectedSegmentIndex)
        if (sender == taskSegmentedControl) {
            switch sender.selectedSegmentIndex {
                case 0:
                    taskType = TaskType.change
                    break
                case 1:
                    taskType = TaskType.throwAway
                    break
                case 2:
                    taskType = TaskType.clean
                    break
                default:
                    break
            }
        }
    }
    
    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
        if initialDateTextField.isFirstResponder {
            initialDateTextField.resignFirstResponder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = Locale.current
            initialDateTextField.text = dateFormatter.string(from: datePickerDate.date)
        } else if notificationTimeTextField.isFirstResponder {
            notificationTimeTextField.resignFirstResponder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            dateFormatter.locale = Locale.current
            notificationTimeTextField.text = dateFormatter.string(from: datePickerTime.date)
        }
    }
    
    func registerNotification(name: String, expirationDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Expiration"
        content.body = name
        content.badge = 1
        
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: expirationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}

extension ItemViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        timeFrameTextField.resignFirstResponder()
        var time = Int((timeFrameTextField.text ?? "0")) ?? 0
        time = time > 999 ? 999 : (time < 0 ? 0 : time)
        timeFrameTextField.text = "\(time)"
    }
}

extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseCategory", for: indexPath) as UICollectionViewCell
        return cell
    }
}
