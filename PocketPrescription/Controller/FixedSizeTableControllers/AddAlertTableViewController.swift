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
    
    // Vars
    var selectedDate: Date!
    let ENTITIE: String = "Alert"
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)    
    
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
       // newAlert.setValue(addAlertDatePicker! , forKey: "scheduleDate")
               
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
    
    
    // MARK: - Core Data
    
    func loadData() {
        
       // Create Fetch Request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)

        request.predicate = NSPredicate(format: "name = %@", "Detail")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "name") as! String)
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

    
    // MARK: - Interactions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let addOrSubtractMoneyVC = segue.destination as! MedicationInclusionTableViewController
        addOrSubtractMoneyVC.callback = { (medication, state) in
             print(medication)
             print(state)
        }
    }
}
