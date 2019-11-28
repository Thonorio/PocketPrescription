//
//  MedicationTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 27/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import os

class MedicationTableViewController: UITableViewController {

    var medicationCollection = [Medication]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* testing listing medication and saving the content
        guard let medication1 = Medication(name: "Paracetamol", packageQuantity: 1, category: "algo", levelOfImportance: LevelOfImportance.normalImportance ) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let medication2 = Medication(name: "Weed", packageQuantity: 1, category: "algo", levelOfImportance: LevelOfImportance.normalImportance ) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let medication3 = Medication(name: "AXIX", packageQuantity: 1, category: "algo", levelOfImportance: LevelOfImportance.normalImportance ) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let medication4 = Medication(name: "LSD", packageQuantity: 1, category: "algo", levelOfImportance: LevelOfImportance.normalImportance ) else {
            fatalError("Unable to instantiate meal1")
        }
        
        medicationCollection += [medication1, medication2, medication3, medication4]
        
        saveMedication()
        */
        
        /* loading medication, throwing an erro because of file location
        if let savedMedication = loadMedication() {
            print(savedMedication)
        } else {
            //loadSampleMedication()
        }
        */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func loadMedication() -> [Medication]? {
        do {
            let codedData = try Data(contentsOf: Medication.ArchiveURL)
            let medicationCollection = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Medication]
            
            os_log("Medication successfully loaded.", log: OSLog.default, type: .debug)
            
            return medicationCollection;
        } catch {
            os_log("Failed to load medication...", log: OSLog.default, type: .error)
            return nil
        }
    }
    
    private func saveMedication() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: medicationCollection, requiringSecureCoding: false)
            
            try data.write(to: Medication.ArchiveURL)
            
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
            
        } catch {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicationCollection.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MedicationViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate medication for the data source layout.
        let medication = medicationCollection[indexPath.row]
        cell.medicationName.text = medication.name
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
