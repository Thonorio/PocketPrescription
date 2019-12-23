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
    @IBOutlet weak var nameAddAlert: UITextField!
    
    //to implement
    //https://medium.com/@tharanit99/how-to-implement-a-inline-date-picker-in-ios-with-swift-4-9f8274460dbc
    
    // Variabels
    var datePiker :  Date?
    
    var inputTexts: [String] = ["Start date", "End date", "Another date"]
    var datePickerIndexPath: IndexPath?
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: "Alert", in: context)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
    }
    
    @IBAction func okAddAlert(_ sender: Any) {
        let newAlert = NSManagedObject(entity: entity!, insertInto: context)
               
        // Create Notification
        self.createNotification()
        
        //Save info to Core Data
        newAlert.setValue(nameAddAlert.text, forKey: "name")
        newAlert.setValue(datePiker! , forKey: "scheduleDate")
               
        self.saveToCoreData()
    }
       
    // Date Picker Listener
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePiker = sender.date
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
       notificationContent.title = nameAddAlert.text ?? "Something went Wrong"
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
    
    // MARK: - Core Data
    
    func saveToCoreData(){
       do {
          try context.save()
         } catch {
          print("Failed saving")
       }
    }
}
