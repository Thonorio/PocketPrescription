//
//  ListOfTemsTableViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 23/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import os
import UIKit
import CoreData

class ListOfItemsTableViewController: UITableViewController  {
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // MARK: - Search
    
    func searchInformation(textDidChange searchText: String, _ entityName: String) -> [NSManagedObject] {
        
        var information: [NSManagedObject] = []
        var predicate: NSPredicate = NSPredicate()

        if !searchText.isEmpty {
           predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
        }else {
           predicate = NSPredicate(value: true)
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return information }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
           information = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
           print("Could not fetch. \(error)")
        }
        
        return information
    }
       
    // MARK: - Core Data
       
    func loadData(_ entityName: String, _ sortBy: String) -> [NSManagedObject] {
        var information: [NSManagedObject] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if(sortBy != nil){
            let sort = NSSortDescriptor(key: sortBy, ascending: true)
            request.sortDescriptors = [sort]
        }
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)            
            information = (result as? [NSManagedObject])!
        } catch {
            print("Failed")
        }
        return information
    }

    func saveToCoreData(){
        do {
          try context.save()
         } catch {
          print("Failed saving")
        }
    }
}
