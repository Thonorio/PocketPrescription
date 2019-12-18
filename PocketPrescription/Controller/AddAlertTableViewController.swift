//
//  AddAlertTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 11/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class AddAlertTableViewController: UITableViewController {

    var medicationInclusionViewCell:MedicationInclusionViewCell?
    var datePiker : String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: "Medication", in: context)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        let addOrSubtractMoneyVC = segue.destination as! MedicationInclusionTableViewController
        addOrSubtractMoneyVC.callback = { (medication, state) in
             print(medication)
             print(state)
        }
    }
    
    @IBAction func okAddAlert(_ sender: Any) {
        let newAlert = NSManagedObject(entity: entity!, insertInto: context)
               
       /* newAlert.setValue(nameAddMedication.text , forKey: "name")
        newAlert.setValue(categoryAddMedication.text , forKey: "repeat")
        newAlert.setValue(datePiker! , forKey: "schedule")
         */
        
        // Add foren key to cor data so it supports medication
        newAlert.setValue("high", forKey: "medication")
               
       saveToCoreData()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        datePiker! = dateFormatter.string(from: sender.date)
        print(datePiker)
    }
    
    func saveToCoreData(){
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
}
