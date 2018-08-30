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

   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var initialDatePicker: UIDatePicker!
    @IBOutlet weak var finalDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = "Teste"
        categoryTextField.text = "bedroom"

    }

    
    @IBAction func saveItem(_ sender: Any) {
        DBManager.insertItem(name: nameTextField.text!, initialDate: initialDatePicker.date, finalDate: finalDatePicker.date, category: HouseCategory(rawValue: categoryTextField.text!)!)
        registerNotification(name: nameTextField.text!, expirationDate: finalDatePicker.date)
        navigationController?.popViewController(animated: true)
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
