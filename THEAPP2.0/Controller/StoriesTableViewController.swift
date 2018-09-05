//
//  StoriesTableViewController.swift
//  TipsScreen
//
//  Created by Ada 2018 on 03/09/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController {
    
    var plist: NSDictionary?
    
    
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 136
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        tableView.register(UINib(nibName: "HeaderSectionTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeader")
        
        tableView.register(UINib(nibName: "CardTableView", bundle: nil), forCellReuseIdentifier: "cell")
        
        let path = Bundle.main.path(forResource: "TipsList", ofType: "plist")
        plist = NSDictionary(contentsOfFile: path!)
        
        for (key, value) in plist! {
            categories.append(key as! String)
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! HeaderSectionTableView
        header.roomLabel.text = categories[section]
        
        return header
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let category = categories[section] as NSString
        let itens = plist![category] as! [NSDictionary]
        return itens.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardTableViewCell

        let category = categories[indexPath.section] as NSString
        
        let itens = plist![category] as! [NSDictionary]
        
        let item = itens[indexPath.row] as NSDictionary
        
        cell.itemNameLabel.text = item["name"] as? String
        cell.itemTimeLabel.text = item["time"] as? String
        cell.itemDescriptionLabel.text = item["description"] as? String
        
        
        return cell
    }

}
