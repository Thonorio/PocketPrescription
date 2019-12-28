//
//  MedicationTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 27/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import os
import UIKit
import CoreData

class MedicationTableViewController: ListOfItemsTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var medicationTableView: UITableView!
    
    // Variables
    let ENTITIE: String = "Medication"
    var medications: [NSManagedObject] = []
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Medication info
        medications = self.loadData(ENTITIE)
        
        // Cell registation
        let nibName = UINib(nibName: "MedicationTableViewCell", bundle: nil)
        medicationTableView.dataSource = self
        medicationTableView.delegate = self
        medicationTableView.register(nibName, forCellReuseIdentifier: "medicationTableViewCell")
                        
        // Search Bar
        searchBar.delegate=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Refresh
        medications = self.loadData(ENTITIE)
        tableView.reloadData()
    }
    
    // MARK: - Functionality
    
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
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationTableViewCell", for: indexPath) as? MedicationTableViewCell else {
           fatalError("The dequeued cell is not an instance of MedicationInclusionViewCell.")
        }
       
        let medication = medications[indexPath.row]
        cell.medicationViewInit("testing", medication.value(forKey: "name") as? String, "ola")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            //Remove Core Data
            context.delete(medications[indexPath.row])
            
            //Remove from list
            medications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)

            saveToCoreData()
        }
    }
    
    // MARK: - Interactions
    
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}
}