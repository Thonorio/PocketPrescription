//
//  AddMedicationTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 28/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import os
import MessageUI

class AddMedicationTableViewController: UITableViewController {
    
    @IBOutlet weak var imgAddMedication: UIImageView!
    @IBOutlet weak var nameAddMedication: UITextField!
    @IBOutlet weak var categoryAddMedication: UITextField!
    @IBOutlet var tableViewConTroller: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(
            AddMedicationHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier:
                AddMedicationHeaderFooterView.reuseIdentifier
        )
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func okConfirmMedication(_ sender: Any) {
     
        guard let medicationTobeAdded = Medication(name: "Paracetamol", packageQuantity: 1, category: "algo", levelOfImportance: LevelOfImportance.normalImportance ) else {
           fatalError("Unable to instantiate meal1")
        }
        saveMedication(medicationTobeAdded)
    }
    
    private func saveMedication(_ medication: Medication) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: medication, requiringSecureCoding: false)
            
            try data.write(to: Medication.ArchiveURL)
            
            os_log("Medication successfully saved.", log: OSLog.default, type: .debug)
            
        } catch {
            os_log("Failed to save medications...", log: OSLog.default, type: .error)
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    
    

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
