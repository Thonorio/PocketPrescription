//
//  MedicationInclusionTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 13/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import os
import CoreData

class MedicationInclusionTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var callback :((String, Bool)->())?
    
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
        
        searchBar.delegate=self
        //tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateInformation()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        var predicate: NSPredicate = NSPredicate()
        
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
        }else {
            predicate = NSPredicate(value: true)
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Medication")
        fetchRequest.predicate = predicate
        
        do {
            medications = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        tableView.reloadData()
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

        // Cell identifier
        let cellIdentifier = "MedicationInclusionViewCell"
              
        // If cell is of the expected type
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicationInclusionViewCell else {
           fatalError("The dequeued cell is not an instance of MedicationInclusionViewCell.")
        }
        
        // Atributes medication based on the inde
        let medicationInfo = medications[indexPath.row]
        currentCell.medicationName.text = medicationInfo.value(forKey: "name") as? String

        // Add beavor to switch
        let medicationSwitch = UISwitch(frame: .zero)
        medicationSwitch.tag = indexPath.row
        
        // Make a reponse when it switches
        medicationSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        // Add the cell to the cels existing in the view
        currentCell.accessoryView = medicationSwitch
        
        return currentCell
    }
    
    @objc func switchChanged (_ cellSwitch: UISwitch!){
        callback?((medications[cellSwitch.tag].value(forKey: "name") as? String)!, cellSwitch.isOn)
    }
}
