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
import CoreData

class AddMedicationTableViewController: UITableViewController {
    
    @IBOutlet weak var imgAddMedication: UIImageView!
    @IBOutlet weak var nameAddMedication: UITextField!
    @IBOutlet weak var categoryAddMedication: UITextField!
    @IBOutlet var tableViewConTroller: UITableViewController!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: "Medication", in: context)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(
            AddMedicationHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier:
                AddMedicationHeaderFooterView.reuseIdentifier
        )
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func okAddMedication(_ sender: Any) {
        let newMedication = NSManagedObject(entity: entity!, insertInto: context)
        
        //default is wrong
        newMedication.setValue(nameAddMedication.text , forKey: "name")
        newMedication.setValue(categoryAddMedication.text , forKey: "category")
        newMedication.setValue("high", forKey: "levelOfImportance")
        
        saveToCoreData()
    }
    
    func saveToCoreData(){
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        okAddMedication(sender)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    

    // MARK: - Table view data source
}
