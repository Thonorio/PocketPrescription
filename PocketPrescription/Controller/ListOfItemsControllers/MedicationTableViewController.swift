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

class MedicationTableViewController: ListOfItemsTableViewController, MedicationTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var medicationTableView: UITableView!
    @IBOutlet var medicationEditMode: UIBarButtonItem!
    @IBOutlet var medicationAddMode: UIBarButtonItem!
    
    // Variables
    let ENTITIE: String = "Medication"
    var medications: [NSManagedObject] = []
    var rowSelected: Int = -1
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        medications = self.loadData(ENTITIE, "name")
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
        
        // Only selectable on eddit mode
        tableView.allowsSelection = false
        
        // Edit mode configs
        tableView.allowsSelectionDuringEditing = true
        cell.editingAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.delegate = self
       
        let medication = medications[indexPath.row]
        cell.medicationViewInit(medication)

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.rowSelected = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "edditMedicationViewControllerSegue", sender: self)
    }
    
    // MARK: - Functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        medications = self.searchInformation(textDidChange: searchText, ENTITIE)
        tableView.reloadData()
    }
    
    @IBAction func medicationEditMode(_ sender: Any) {
        super.setEditing(!self.isEditing , animated: true)
        self.medicationAddMode.isEnabled = !self.isEditing
    }
    
    // MARK: - Delegate
    func medicationShowInfoForCell(_ medication: NSManagedObject) {
        
        let infoController = UIViewController()
        infoController.preferredContentSize = CGSize(width: 350,height: 50)
        
        let description = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 50))
        description.text = medication.value(forKey: "infoDescription") as? String
        description.textAlignment = .natural
        infoController.view.addSubview(description)
        
        let descriptionRadiusAlert = UIAlertController(title: medication.value(forKey: "name") as? String, message: nil, preferredStyle: .alert)
        descriptionRadiusAlert.setValue(infoController, forKey: "contentViewController")
        
        // Add Done
        descriptionRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default))
        
        // Show allert
        self.present(descriptionRadiusAlert, animated: true)
    }
    
    // MARK: - Interactions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddMedicationTableViewController {
            let destinationVC = segue.destination as! AddMedicationTableViewController
            destinationVC.edditMode = self.isEditing
            if(self.isEditing){
                destinationVC.medicationInfo = self.medications[rowSelected]
            }
        }
        if segue.destination is AddMedicationTableViewController {
            let destinationVC = segue.destination as! AddMedicationTableViewController
            destinationVC.edditMode = self.isEditing
            if(self.isEditing){
                destinationVC.medicationInfo = self.medications[rowSelected]
            }
        }
    }
    
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}
}
