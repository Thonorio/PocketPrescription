//
//  MedicationTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 27/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import os
import CoreData

class MedicationTableViewController: UITableViewController {

    @IBOutlet weak var medicationTableView: UITableView!
    var medications: [NSManagedObject] = []
    var refresher: UIRefreshControl!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(MedicationTableViewController.updateInformation), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        //tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateInformation()
    }
    
    @objc func updateInformation(){
        self.loadData()
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    func loadData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Medication")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            medications = (result as? [NSManagedObject])!
            
        } catch {
            print("Failed")
        }
    }
    
    
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medications.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cellIdentifier = "MedicationViewCell"
               
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Fetches the appropriate medication for the data source layout.
        let medication = medications[indexPath.row]
        cell.medicationName.text = medication.value(forKey: "name") as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let commit = medications[indexPath.row]
            context.delete(commit)
            medications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)

            do {
               try context.save()
              } catch {
               print("Failed saving")
            }
        }
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
