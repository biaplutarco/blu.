//
//  ItemViewController.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import UserNotifications

enum TimeFrame: Int {
    case day = 86400
    case week = 604800
    case month = 2592000
    case year = 31104000
}

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var taskSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var initialDateTextField: UITextField!
    @IBOutlet weak var timeFrameTextField: UITextField!
    @IBOutlet weak var timeUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var notificationTimeTextField: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    var pickerView = UIPickerView()
    
    let timeUnits: [String] = ["Day", "Week", "Month", "Year"]
    let taskCategories: [TaskType] = [.change, .throwAway, .clean]
    
    var currentHouseCategory = Int()
    var item: Item?
    var datePickerDate = UIDatePicker()
    var datePickerTime = UIDatePicker()
    var timeValue = Int()
    var timeUnitInput = Int()
    var timeFrame: TimeInterval {
        get {
            switch timeUnitInput {
                case 0:
                    return Double(timeValue * TimeFrame.day.rawValue)
                case 1:
                    return Double(timeValue * TimeFrame.week.rawValue)
                case 2:
                    return Double(timeValue * TimeFrame.month.rawValue)
                case 3:
                    return Double(timeValue * TimeFrame.year.rawValue)
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
    
    func setTimeFrameFrom(start: Date, finish: Date) {
        let timeFrame = Int(finish.removeTime().timeIntervalSince(start.removeTime()))
        if timeFrame % TimeFrame.year.rawValue == 0 {
            timeValue = timeFrame / TimeFrame.year.rawValue
            timeUnitInput = 3
        } else if timeFrame % TimeFrame.month.rawValue == 0 {
            timeValue = timeFrame / TimeFrame.month.rawValue
            timeUnitInput = 2
        } else if timeFrame % TimeFrame.week.rawValue == 0 {
            timeValue = timeFrame / TimeFrame.week.rawValue
            timeUnitInput =  1
        } else {
            timeValue = timeFrame / TimeFrame.day.rawValue
            timeUnitInput = 0
        }
        updateTimeFramePickerView()
        updateTextFields()
    }
    
    func updateTimeFramePickerView() {
        pickerView.selectRow(timeValue-1, inComponent: 0, animated: true)
        pickerView.selectRow(timeUnitInput, inComponent: 1, animated: true)
    }
    
    func updateTextFields() {
        initialDateTextField.text = datePickerDate.date.toString(format: "dd/MM/yyyy")
        timeFrameTextField.text = "\(timeValue) \(timeUnits[timeUnitInput])"+(timeValue > 1 ? "s" :"")
        notificationTimeTextField.text = datePickerTime.date.toString(format: "hh:mm")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = self.item {
            if let initialDate = item.initialDate, let finalDate = item.finalDate {
                datePickerDate.date = initialDate.removeTime()
                datePickerTime.date = finalDate
                self.setTimeFrameFrom(start: initialDate.removeTime(), finish: finalDate)
            }
            
            if let name = item.name {
                nameTextField.text = name
            }
            
            if let task = item.taskType {
                taskSegmentedControl.changeSelectedIndex(to: taskCategories.index(of: TaskType(rawValue: task) ?? .change) ?? 0)
            }
            
            if let category = item.category {
                currentHouseCategory = HouseCategory.allCases.index(of: HouseCategory(rawValue: category) ?? .bedroom) ?? 0
            }
            
        } else {
            datePickerDate.date = datePickerDate.date.removeTime()
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        datePickerDate.datePickerMode = .date
        initialDateTextField.inputView = datePickerDate
        initialDateTextField.inputAccessoryView = accessoryToolbar
        //timeFrameTextField.delegate = self
        datePickerTime.datePickerMode = .time
        notificationTimeTextField.inputView = datePickerTime
        notificationTimeTextField.inputAccessoryView = accessoryToolbar
        
        collectionView.register(UINib.init(nibName: "AddItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HouseCategory")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timeFrameTextField.inputView = pickerView
        timeFrameTextField.inputAccessoryView = accessoryToolbar
        
        label1.font = UIFont.systemFont(ofSize: fontSize)
        label2.font = UIFont.systemFont(ofSize: fontSize)
        label3.font = UIFont.systemFont(ofSize: fontSize)
        label4.font = UIFont.systemFont(ofSize: fontSize)
        label5.font = UIFont.systemFont(ofSize: fontSize)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.heightAnchor.constraint(equalToConstant: heightSize).isActive = true
        
        initialDateTextField.translatesAutoresizingMaskIntoConstraints = false
        initialDateTextField.heightAnchor.constraint(equalToConstant: heightSize).isActive = true
        
        timeFrameTextField.translatesAutoresizingMaskIntoConstraints = false
        timeFrameTextField.heightAnchor.constraint(equalToConstant: heightSize).isActive = true

        notificationTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        notificationTimeTextField.heightAnchor.constraint(equalToConstant: heightSize).isActive = true
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        let selectedItem = IndexPath(item: currentHouseCategory, section: 0)
        collectionView.selectItem(at: selectedItem, animated: true, scrollPosition: .centeredVertically)
        collectionView.scrollToItem(at: selectedItem, at: .centeredHorizontally, animated: true)
        updateTimeFramePickerView()
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOK)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveItem(_ sender: Any) {
        guard let name = nameTextField.text else {
            alert(title: "Invalid name", message: "A name is required")
            return
        }
        
        guard currentHouseCategory >= 0 && currentHouseCategory < HouseCategory.allCases.count else {
            alert(title: "Invalid category", message: "A item needs a room")
            return
        }
        
        guard timeValue > 0, timeValue <= 999 else {
            alert(title: "Invalid timeframe", message: "A time frame needs a value between 1-999")
            return
        }
        
        let houseCategory = HouseCategory.allCases[currentHouseCategory]
        let calendar = Calendar.current
        let time = TimeInterval(calendar.component(.hour, from: datePickerTime.date) * 3600 + calendar.component(.minute, from: datePickerTime.date) * 60)
        let initialDate = datePickerDate.date.removeTime().addingTimeInterval(time)
        let finalDate = initialDate.addingTimeInterval(timeFrame)
        if let item = self.item {
            let identifier = item.description
            item.name = name
            item.taskType = taskCategories[taskSegmentedControl.selectedSegmentIndex].rawValue
            item.initialDate = initialDate
            item.finalDate = finalDate
            item.category = houseCategory.rawValue
            try? DBManager.shared.save()
            updateNotification(identifier: identifier, newItem: item)
        } else {
            if let object = DBManager.shared.insertItem(name: name, initialDate: initialDate, finalDate: finalDate, category: houseCategory) {
                registerNotification(item: object)
            }
        }
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
//        if initialDateTextField.isFirstResponder {
//            initialDateTextField.resignFirstResponder()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd/MM/yyyy"
//            dateFormatter.locale = Locale.current
//            initialDateTextField.text = dateFormatter.string(from: datePickerDate.date)
//        } else if notificationTimeTextField.isFirstResponder {
//            notificationTimeTextField.resignFirstResponder()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "hh:mm"
//            dateFormatter.locale = Locale.current
//            notificationTimeTextField.text = dateFormatter.string(from: datePickerTime.date)
//        }
        
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        } else if initialDateTextField.isFirstResponder {
            initialDateTextField.resignFirstResponder()
        } else if notificationTimeTextField.isFirstResponder {
            notificationTimeTextField.resignFirstResponder()
        } else if timeFrameTextField.isFirstResponder {
            timeFrameTextField.resignFirstResponder()
            timeValue = pickerView.selectedRow(inComponent: 0)+1
            timeUnitInput = pickerView.selectedRow(inComponent: 1)
        }
        updateTextFields()
    }
    
    func updateNotification(identifier: String, newItem: Item) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        registerNotification(item: newItem)
    }
    
    func registerNotification(item: Item) {
        guard let name = item.name, let category = item.category, let initialDate = item.initialDate, let finalDate = item.finalDate, let task = item.taskType else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "You need to "+task+" "+name+"today"
        content.body = "Last time it was done: \(initialDate)"
        content.badge = 1
        //        if let numberBadge = content.badge?.intValue {
        //            content.badge = NSNumber(integerLiteral: numberBadge + 1)
        //        } else {
        //            content.badge = NSNumber(integerLiteral: 1)
        //        }
        
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: finalDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let requestIdentifier = item.description
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}

//extension AddItemViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        timeFrameTextField.resignFirstResponder()
//        var time = Int((timeFrameTextField.text ?? "0")) ?? 0
//        time = time > 999 ? 999 : (time < 0 ? 0 : time)
//        timeFrameTextField.text = "\(time)"
//    }
//}

extension AddItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HouseCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let category = HouseCategory.allCases[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseCategory", for: indexPath) as! AddItemCollectionViewCell
        
        cell.nameRoom.text = category.rawValue
        cell.setIcon(image: UIImage(named: category.rawValue)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentHouseCategory = indexPath.row
    }
    
}

extension AddItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 999
        } else {
            return timeUnits.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row+1)"
        } else {
            return timeUnits[row]
        }
    }
}

extension AddItemViewController {
    var fontSize: CGFloat {
        get {
            if UIScreen.main.nativeBounds.width == 640 {
                return 14
            } else {
                return 18
            }
        }
    }
    
    var heightSize: CGFloat {
        get {
            if UIScreen.main.nativeBounds.width == 640 {
                return 24
            } else {
                return 40
            }
        }
    }
}

extension AddItemViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func removeTime() -> Date {
        let calendar = Calendar.current
        let time = TimeInterval(calendar.component(.hour, from: self) * 3600 + calendar.component(.minute, from: self) * 60 + calendar.component(.second, from: self))
        return self.addingTimeInterval(-time)
    }
}
