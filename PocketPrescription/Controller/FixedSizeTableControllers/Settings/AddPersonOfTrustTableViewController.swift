//
//  PersonOfTrustTableViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 13/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class AddPersonOfTrustTableViewController: UITableViewController {

    // Outlet
    @IBOutlet weak var personOfTrustName: UILabel!
    @IBOutlet weak var personOfTrustPhoneNumber: UILabel!
    @IBOutlet var personOfTrustOKButton: UIBarButtonItem!
    
    // Vars
    let ENTITIE: String = "PersonOfTrust"
    var alertSubmit: UIAlertAction?
    var personOfTrustNameText: String = "" {
        willSet(newValue) {
            self.personOfTrustOKButton.isEnabled = !newValue.isEmpty && !self.personOfTrustPhoneNumberText.isEmpty ? true : false
        }
    }
    var personOfTrustPhoneNumberText: String = "" {
        willSet(newValue) {
            self.personOfTrustOKButton.isEnabled = !self.personOfTrustNameText.isEmpty && !newValue.isEmpty ? true : false
        }
    }
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
            case 0:
                self.nameLabel()
            case 1:
                self.phoneNumberLabel()
            default:
                return
            }
    }
    
    // MARK: - Functionality
    func nameLabel ()  {
        let alertController = UIAlertController(title: "Person of Trust", message: nil, preferredStyle: .alert)
        
        // Add Ok (Submit) Option and info destination
        alertSubmit = UIAlertAction(title: "Done", style: .default, handler: { [weak alertController] (_) in
            self.personOfTrustNameText = alertController?.textFields![0].text ?? "error"
            self.personOfTrustName.text = alertController?.textFields![0].text
        })
        
        // Add Cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Ok button starts as not enabled
        alertSubmit!.isEnabled = false
        
        // Add the text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Name someone you trust"
            
            // Add listener to text field (when empty)
            textField.addTarget(self, action: #selector(AddPersonOfTrustTableViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        }
        
        // Grab the value from the text field
        alertController.addAction(alertSubmit!)
        alertController.addAction(cancelAction)
        
        // Show allert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func phoneNumberLabel ()  {
        let alertController = UIAlertController(title: "Phone number", message: nil, preferredStyle: .alert)
        
        // Add Ok (Submit) Option and info destination
        alertSubmit = UIAlertAction(title: "Done", style: .default, handler: { [weak alertController] (_) in
            self.personOfTrustPhoneNumberText = alertController?.textFields![0].text ?? "000000000"
            self.personOfTrustPhoneNumber.text = alertController?.textFields![0].text
        })
        
        // Add Cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Ok button starts as not enabled
        alertSubmit!.isEnabled = false
        
        // Add the text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "What is the phone number"
            textField.keyboardType = .numberPad
            // Add listener to text field (when empty)
            textField.addTarget(self, action: #selector(AddPersonOfTrustTableViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        }
        
        // Grab the value from the text field
        alertController.addAction(alertSubmit!)
        alertController.addAction(cancelAction)
        
        // Show allert
        self.present(alertController, animated: true, completion: nil)
    }
    
    // When the text field dosn´t have anny text the Ok button is not available
    @objc func textFieldDidChange(sender: UITextField){
        if sender.text == "" {
            alertSubmit!.isEnabled = false
        }else{
            alertSubmit!.isEnabled = true
        }
    }
    
    @IBAction func submitOk(_ sender: Any) {
        let newMedication = NSManagedObject(entity: entity!, insertInto: context)
        
        newMedication.setValue(personOfTrustNameText , forKey: "name")
        newMedication.setValue(Int(personOfTrustPhoneNumberText) ?? 0, forKey: "phoneNumber")
        newMedication.setValue(true, forKey: "state")
        
        // Unwind to previous page
        self.performSegue(withIdentifier: "unwindFromPersonOfTrustToSettings", sender: self)

        self.saveToCoreData()
    }
    
    func saveToCoreData(){
       do {
          try context.save()
         } catch {
          print("Failed saving")
       }
    }
}
