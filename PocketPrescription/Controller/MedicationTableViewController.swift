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

class MedicationTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var medicationTableView: UITableView!
        
    // Vars
    var refresher: UIRefreshControl!
    var medications: [NSManagedObject] = []
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Medication info
        self.loadData()
        
        // Cell registation
        let nibName = UINib(nibName: "MedicationTableViewCell", bundle: nil)
        medicationTableView.dataSource = self
        medicationTableView.delegate = self
        medicationTableView.register(nibName, forCellReuseIdentifier: "medicationTableViewCell")
        
        // Refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(MedicationTableViewController.updateInformation), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        tableView.tableFooterView = UIView()
        
        // Search Bar
        searchBar.delegate=self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Update Medication
        updateInformation()
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
    
    @objc func updateInformation(){
        self.loadData()
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}
    
    
    // MARK: - Search
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
    
    // MARK: - Core Data
    
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
    
    func saveToCoreData(){
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
}
