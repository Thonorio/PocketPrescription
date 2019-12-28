//
//  AlertCollectionViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 20/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import os
import UIKit
import CoreData

class AlertTableViewController: ListOfItemsTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var alertTableView: UITableView!
    @IBOutlet var alertEditMode: UIBarButtonItem!
    
    // Variables
    let ENTITIE: String = "Alert"
    var alerts: [NSManagedObject] = []
    
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        // Load Alerts info
        alerts = self.loadData(ENTITIE)
        // Cell registation
        let nibName = UINib(nibName: "AlertTableViewCell", bundle: nil)
        alertTableView.dataSource = self
        alertTableView.delegate = self
        alertTableView.register(nibName, forCellReuseIdentifier: "alertTableViewCell")
        
        // Search Bar
        searchBar.delegate=self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Refresh
        alerts = self.loadData(ENTITIE)
        tableView.reloadData()
    }
    
    // MARK: - Functionality
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        alerts = self.searchInformation(textDidChange: searchText, ENTITIE)
        tableView.reloadData()
    }
    
    @IBAction func alertEditMode(_ sender: Any) {
        super.setEditing(!self.isEditing , animated: true)
    }
    
    // MARK: - UICollectionViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alerts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alertTableViewCell", for: indexPath) as? AlertTableViewCell else {
            fatalError("The dequeued cell is not an instance of AlertTableViewCell.")
        }
        
        // Only selectable on eddit mode
        tableView.allowsSelection = false
        
        // Edit mode configs
        tableView.allowsSelectionDuringEditing = true
        cell.editingAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let alert = alerts[indexPath.row]
        cell.alertViewInit(alert.value(forKey: "name") as? String, true)
        //print("id \(alerts[indexPath.row].objectID)")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //Remove Core Data
            context.delete(alerts[indexPath.row])
            
            //Remove from list
            alerts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)

            saveToCoreData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
    }
    
    // MARK: - Interactions
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}
}
