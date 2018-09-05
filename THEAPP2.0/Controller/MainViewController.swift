//
//  ViewController.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 28/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    var currentCategory = Int()
    var itens = [Item]()
    var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        itens = DBManager.shared.fetchAllItens()

        
        tableView.register(UINib.init(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "todayCell")
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "RoomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        UNUserNotificationCenter.current().delegate = self
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { timer in
            self.checkAndRefreshItens()
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        self.valueChanged(segmentControl)
        self.navigationController?.navigationBar.isTranslucent = true
        tableView.reloadData()
    }
    
    
    @IBAction func valueChanged(_ sender: CustomSegmentedControl) {
        sender.changeSelectedIndex(to: sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            self.itens = DBManager.shared.fetchItensExpiringToday()
            break
        case 1:
            self.itens = DBManager.shared.fetchItensExpiringThisWeek()
            break
        case 2:
            self.itens = DBManager.shared.fetchItensExpiringThisMonth()
            break
        case 3:
            self.itens = DBManager.shared.fetchItensExpiringAfterThisMonth()
            break
        default:
            break
        }
        self.itens = self.itens.filter { item in
            return item.category == HouseCategory.allCases[currentCategory].rawValue
        }
        self.itens.sort(by: { i1, i2 in
            guard let dateA = i1.finalDate, let dateB = i2.finalDate else {
                return false
            }
            return dateA < dateB
        })
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let destination = segue.destination as! AddItemViewController
            if let item = sender as? Item {
                destination.item = item
            }
        } else if segue.identifier == "Tips" {
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    func checkAndRefreshItens() {
        let itens = DBManager.shared.fetchAllItens().filter {
            return $0.isDone
        }
        
        for item in itens {
            DBManager.shared.refreshItem(item: item)
        }
        
        self.valueChanged(segmentControl)
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itens[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TaskTableViewCell
        cell.selectionStyle = .none

        cell.item = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let item = self.itens[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            DBManager.shared.delete(item: item)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.description])
            self.itens.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            self.collectionView.reloadData()
        }
        deleteAction.backgroundColor = UIColor(red: 0.914, green: 0.294, blue: 0.294, alpha: 1)
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "AddItem", sender: item)
        }
        editAction.backgroundColor = UIColor(named: "MainColor")
        
        var actions: [UITableViewRowAction] = [deleteAction, editAction]
        if segmentControl.selectedSegmentIndex == 0 {
            let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (action, indexPath) in
                item.isDone = true
                if DBManager.shared.refreshItem(item: item) {
                    self.itens.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            doneAction.backgroundColor = UIColor(red: 0.294, green: 0.914, blue: 0.294, alpha: 1)
            actions.append(doneAction)
        }
        return actions
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HouseCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RoomCollectionViewCell
    
        let category = HouseCategory.allCases[indexPath.row]
        
        cell.roomLabel.text = category.rawValue
        cell.tasksRoom.text = "You have \(DBManager.shared.countItens(ofType: category)) tasks here"
        cell.setIcon(image: UIImage(named: category.rawValue)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentCategory = indexPath.row
        self.valueChanged(self.segmentControl)
    }
    
}

extension MainViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
