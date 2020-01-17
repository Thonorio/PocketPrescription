//
//  EditProfileTableViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 13/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var edditProfileName: UILabel!
    @IBOutlet weak var edditProfileEmail: UILabel!
    @IBOutlet var edditProfileOKButton: UIBarButtonItem!
    
    let ENTITIE: String = "Person"
    var alertSubmit: UIAlertAction?
    var edditProfileNameText: String = "" {
        willSet(newValue) {
            self.edditProfileOKButton.isEnabled = !newValue.isEmpty && !self.edditProfileEmailText.isEmpty ? true : false
        }
    }
    var edditProfileEmailText: String = "" {
        willSet(newValue) {
            self.edditProfileOKButton.isEnabled = !self.edditProfileNameText.isEmpty && !newValue.isEmpty ? true : false
        }
    }
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
           switch indexPath.row {
               case 0:
                   self.nameLabel()
               case 1:
                   self.emailLabel()
               default:
                   return
               }
       }
    
    
    // MARK: - Functionality
    func nameLabel ()  {
        let alertController = UIAlertController(title: "Person of Trust", message: nil, preferredStyle: .alert)
        
        // Add Ok (Submit) Option and info destination
        alertSubmit = UIAlertAction(title: "Done", style: .default, handler: { [weak alertController] (_) in
            self.edditProfileNameText = alertController?.textFields![0].text ?? "error"
            self.edditProfileName.text = alertController?.textFields![0].text
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
    
    func emailLabel ()  {
        let alertController = UIAlertController(title: "Email", message: nil, preferredStyle: .alert)
        
        // Add Ok (Submit) Option and info destination
        alertSubmit = UIAlertAction(title: "Done", style: .default, handler: { [weak alertController] (_) in
            self.edditProfileEmailText = alertController?.textFields![0].text ?? "000000000"
            self.edditProfileEmail.text = alertController?.textFields![0].text
        })
        
        // Add Cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Ok button starts as not enabled
        alertSubmit!.isEnabled = false
        
        // Add the text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "What is the email"
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
    
    // MARK: - Table view data source
    
    @IBAction func submitOk(_ sender: Any) {
        let newMedication = NSManagedObject(entity: entity!, insertInto: context)
        
        newMedication.setValue(edditProfileNameText , forKey: "name")
        newMedication.setValue(edditProfileEmailText, forKey: "email")
        
        // Unwind to previous page
        self.performSegue(withIdentifier: "unwindFromEdditProfileToSettings", sender: self)
        
        self.saveToCoreData()
    }
    
    func loadData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            // Usefull on first Run
            if(result.count == 0){
                return
            }
            
            let lastResult = result[result.count - 1] as! NSManagedObject
            let name = lastResult.value(forKey: "name") as! String
            let email = lastResult.value(forKey: "email") as! String
            
            self.edditProfileNameText = name
            self.edditProfileName.text = name
            self.edditProfileEmailText = email
            self.edditProfileEmail.text = email
            
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
