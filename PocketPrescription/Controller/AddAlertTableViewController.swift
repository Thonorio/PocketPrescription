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

    
    @IBOutlet weak var nameAddAlert: UITextField!
    var datePiker :  Date?
    
    var medicationInclusionViewCell:MedicationInclusionViewCell?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: "Alert", in: context)
    
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
               
        newAlert.setValue(nameAddAlert.text , forKey: "name")
        newAlert.setValue(datePiker! , forKey: "scheduleDate")
        
               
       saveToCoreData()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePiker = sender.date
    }
    
    func saveToCoreData(){
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
}
