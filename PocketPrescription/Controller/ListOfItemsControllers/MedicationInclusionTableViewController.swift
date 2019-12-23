//
//  MedicationInclusionTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 13/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import os
import UIKit
import CoreData

class MedicationInclusionTableViewController: ListOfItemsTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var medicationInclusionTableView: UITableView!
       
    // Variables
    let ENTITIE: String = "Medication"
    var callback :((String, Bool)->())?
    var medications: [NSManagedObject] = []

    override func viewDidLoad() {
       super.viewDidLoad()
              
       // Load Alerts info
       medications = self.loadData(ENTITIE)

       // Cell registation
       let nibName = UINib(nibName: "MedicationInclusionTableViewCell", bundle: nil)
       medicationInclusionTableView.dataSource = self
       medicationInclusionTableView.delegate = self
       medicationInclusionTableView.register(nibName, forCellReuseIdentifier: "medicationInclusionTableViewCell")
                      
       // Search Bar
       searchBar.delegate=self
    }

    override func viewDidAppear(_ animated: Bool) {
       // Refresh
       medications = self.loadData(ENTITIE)
       tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
       medications = self.searchInformation(textDidChange: searchText, ENTITIE)
       tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationInclusionTableViewCell", for: indexPath) as? MedicationInclusionTableViewCell else {
            fatalError("The dequeued cell is not an instance of MedicationInclusionTableViewCell.")
        }
        
        // Atributes medication based on the inde
        let medication = medications[indexPath.row]
        cell.medicationViewInit("testing", medication.value(forKey: "name") as? String, false)

        // Make a reponse when it switches
        cell.medicationState.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    @objc func switchChanged (_ cellSwitch: UISwitch!){
        callback?((medications[cellSwitch.tag].value(forKey: "name") as? String)!, cellSwitch.isOn)
    }
}
