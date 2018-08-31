//
//  ViewController.swift
//  THEAPP2.0
//
//  Created by Ada 2018 on 28/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(DBManager.fetchAllItens())
        
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


