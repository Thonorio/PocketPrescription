//
//  AlertCollectionViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 20/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData
import os

class AlertTableViewController: UITableViewController {
    
    var alerts: [NSManagedObject] = []
    
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
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateInformation()
    }
    
    func loadData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Alert")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            alerts = (result as? [NSManagedObject])!
            
        } catch {
            print("Failed")
        }
    }
    
    @objc func updateInformation(){
        self.loadData()
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    func saveToCoreData(){
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alerts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cellIdentifier = "AlertViewCell"
               
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlertViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Fetches the appropriate medication for the data source layout.
        let alert = alerts[indexPath.row]
        cell.alertName.text = alert.value(forKey: "name") as? String

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
}
