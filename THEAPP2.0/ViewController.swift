//
//  ViewController.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 28/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(DBManager.fetchAllItens())
        
        tableView.register(UINib.init(nibName: "TodayTableViewCell", bundle: nil), forCellReuseIdentifier: "todayCell")
        //tableView.register(UINib.init(nibName: "SectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "sectionHeadertCell")
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func valueChanged(_ sender: CustomSegmentedControl) {
        sender.changeSelectedIndex(to: sender.selectedSegmentIndex)
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.fetchAllItens().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = DBManager.fetchAllItens()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayTableViewCell
        
        cell.nameLabel.text = item.name
        cell.categoryLabel.text = item.category
    
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeadertCell") as! SectionHeaderView
//        header.backgroundColor = .white
//        return header
//    }
}
