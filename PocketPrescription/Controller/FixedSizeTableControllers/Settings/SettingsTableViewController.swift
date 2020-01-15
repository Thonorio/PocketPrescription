//
//  SettingsTableViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 13/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Limit Amount of Colls
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    
    // MARK: - Interactions
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}
}
