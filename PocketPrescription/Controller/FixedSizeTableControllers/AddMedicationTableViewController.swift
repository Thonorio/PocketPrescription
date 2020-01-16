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
    
    @IBOutlet weak var nameAddMedication: UITextField!
    @IBOutlet weak var categoryAddMedication: UITextField!
    @IBOutlet weak var addMedicationOkButton: UIBarButtonItem!
    
    // Fields to take into acount
    var nameAddMedicationText: String = "" {
        willSet(newValue) {
            self.addMedicationOkButton.isEnabled = true // ( !newValue.isEmpty && !self.categoryAddMedicationText.isEmpty ) ? true : false
        }
    }
    var categoryAddMedicationText: String = "" {
        willSet(newValue) {
            self.addMedicationOkButton.isEnabled = true //(!self.nameAddMedicationText.isEmpty && !newValue.isEmpty ) ? true : false
        }
    }
    
    // Variables
    let ENTITIE: String = "Medication"
    var medications: [NSManagedObject] = []

    // View will be used in what way
    var edditMode: Bool = false
    var edditRowId: Int = 0
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(
            AddMedicationHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier:
                AddMedicationHeaderFooterView.reuseIdentifier
        )
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (edditMode){
            self.loadData()
        }
        tableView.reloadData()
    }
    
    // MARK: - Functionality
    
    @IBAction func okAddMedication(_ sender: Any) {
        let newMedication = NSManagedObject(entity: entity!, insertInto: context)
        
        //default is wrong
        newMedication.setValue(nameAddMedication.text , forKey: "name")
        newMedication.setValue(categoryAddMedication.text , forKey: "category")
        //newMedication.setValue("high", forKey: "levelOfImportance")
        
        saveToCoreData()
    }
    
    // MARK: - Core Data
    func loadData() {
        // Create Fetch Request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)
        request.returnsObjectsAsFaults = false
        
        let lastResult: NSManagedObject
        var name: String = "Detail"
        do {
            let result = try context.fetch(request)
            if(result.count == 0){
                return
            }
            lastResult = result[self.edditRowId] as! NSManagedObject
            name = lastResult.value(forKey: "name") as! String
        } catch {
            print("Failed")
        }
        
        self.nameAddMedicationText = name
        self.nameAddMedication.text = name
    }
    
    func saveToCoreData(){
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    // MARK: - Interactions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.okAddMedication(sender as Any)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
}
