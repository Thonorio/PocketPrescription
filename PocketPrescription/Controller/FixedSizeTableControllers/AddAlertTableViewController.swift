//
//  AddAlertTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 11/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddAlertTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

        
    //Outlets
    @IBOutlet weak var addAlertDatePicker: UIDatePicker!
    @IBOutlet weak var addAlertRepeatInterval: UILabel!
    @IBOutlet weak var addAlertLabel: UILabel!
    @IBOutlet weak var addAlertStartDate: UILabel!
    @IBOutlet weak var addAlertEndDate: UILabel!
    @IBOutlet weak var addAlertMedicationList: UILabel!
    
    // Variables
    var selectedDate: Date!
    let ENTITIE: String = "Alert"
    var medications: [NSManagedObject] = []
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)    
    
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        // Inicialize Date
        selectedDate = self.getDataFormated()
        
        // Add Listener to the Date Picker
        addAlertDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
        
        // Limit Amount of Colls
        tableView.tableFooterView = UIView()
    }    
    
    // MARK: - Functionality
    
    @IBAction func okAddAlert(_ sender: Any) {
        let newAlert = NSManagedObject(entity: entity!, insertInto: context)
            
        // Create Notification
        self.createNotification()
        
        //Save info to Core Data
        newAlert.setValue(addAlertLabel.text, forKey: "name")
        for med in self.medications {
            newAlert.setValue( NSSet(object: med), forKey: "medications")
        }
               
        self.saveToCoreData()
    }
    
    // Function executed by the listener
    @objc func dateChanged (){
        selectedDate = self.getDataFormated()
    }
    
    // Translate UIDataPiker into  Date
    func getDataFormated () -> Date {
        // Format to usable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // Return the Date
        let dateAsString = dateFormatter.string(from: addAlertDatePicker.date)
        return dateFormatter.date(from: dateAsString)!
    }
    
    func alertEditLabel () {
        // Create alert controller.
        let alertController = UIAlertController(title: "Editing Label", message: nil, preferredStyle: .alert)

        // COnfigure what to show inside it
        alertController.addTextField { (textField) in
            textField.text = "Add a Custom Label"
        }

        //  Grab the value from the text field
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
            self.addAlertLabel.text = alertController?.textFields![0].text
        }))

        // Show allert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Core Data
    
    func loadData() {
        
       // Create Fetch Request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)

        request.predicate = NSPredicate(format: "name = %@", "Detail")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
             //  print(data.value(forKey: "id") as! Int)
          }
            
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
    
    // MARK: - Notifications
    
    private func createNotification(){
       UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
           switch notificationSettings.authorizationStatus {
               case .notDetermined:
                   self.requestAuthorization(completionHandler: { (success) in
                       guard success else { return}

                       // Schedule Local Notification
                       self.scheduleLocalNotification()
                   })
               
               case .authorized:
                   // Schedule Local Notification
                   self.scheduleLocalNotification()
               
               case .denied:
                   print("Application Not Allowed to Display Notifications")
               default: break
           }
       }
    }

    // Notification Center
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
       // Request Authorization
       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
           if let error = error {
               print("Request Authorization Failed (\(error), \(error.localizedDescription))")
           }
           completionHandler(success)
       }
    }

    private func scheduleLocalNotification() {
       // Create Notification Content
       let notificationContent = UNMutableNotificationContent()
       
       // Configure Notification Content
       notificationContent.title = addAlertLabel.text ?? "Something went Wrong"
       notificationContent.body = "Remeber to take: "

       // Add Trigger
       let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)

       // Create Notification Request
       let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)

       // Add Request to User Notification Center
       UNUserNotificationCenter.current().add(notificationRequest) { (error) in
           if let error = error {
               print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
           }
       }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.alert])
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
            // Repeat
            case 0:
                self.alertEditLabel()
            // Label
            case 1:
                self.alertEditLabel()
            // Starts
            case 2:
                self.alertEditLabel()
            // Ends
            case 3:
                self.alertEditLabel()
            default:
                return
            }
    }

    
    // MARK: - Interactions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.destination is MedicationInclusionTableViewController
        {
            print("sent")
            let vc = segue.destination as? MedicationInclusionTableViewController
            vc?.medications2 = self.medications
        }

        let addOrSubtractMoneyVC = segue.destination as! MedicationInclusionTableViewController
        addOrSubtractMoneyVC.callback = { (medication, state) in
            let currentMedicationText = self.addAlertMedicationList.text ?? ""
            let medicationName = medication.value(forKey: "name") as? String  ?? ""
            
            // Easier to read (Note: medication is an optional)
            if state == true {
                // Append to last spot
                self.medications.append(medication)
                self.addAlertMedicationList.text = currentMedicationText + " " + medicationName
            }else{
                // Remove filterd object
                self.medications = self.medications.filter{ $0 != medication }
                self.addAlertMedicationList.text = currentMedicationText.replacingOccurrences(of: medicationName, with: "")
            }
        }
    }
}
