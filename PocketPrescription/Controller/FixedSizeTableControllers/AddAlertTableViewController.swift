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

class AddAlertTableViewController: UITableViewController, UNUserNotificationCenterDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
       
        
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
    var alertSubmit: UIAlertAction?
    var repeatIntervalHours: String?
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)    
    
    
    // MARK: - Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        // Inicialize Date
        selectedDate = self.addAlertDatePicker.date

        // Add Listener to the Date Picker
        addAlertDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self

        // Limit Amount of Colls
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
            // Repeat
            case 0:
                // Create alert controller.
                self.alertEditRepeat()
            // Label
            case 1:
                self.alertEditLabel()
            // Starts
            case 2:
                self.alertEditStartDate()
            // Ends
            case 3:
                self.alertEditEndDate()
            default:
                return
            }
    }
    
    
     // MARK: - UIPikerView protocol implementacion
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Easier to read
        let numberOfHoursInADay = 24
        return numberOfHoursInADay
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) Hours"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.repeatIntervalHours = "\(row + 1) Hours"
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
    
    // When the text field dosn´t have anny text the Ok button is not available
    @objc func textFieldDidChange(sender: UITextField){
        if sender.text == "" {
            alertSubmit!.isEnabled = false
        }else{
            alertSubmit!.isEnabled = true
        }
    }
    
    // MARK: - Alert Functionalities
    
    // Todo Shpuld be hours not hours of the day
    func alertEditRepeat ()  {
        // Create and configure view controller
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 250)

        // Create and add data picker to view controller
        let numberOfHoursPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        numberOfHoursPicker.delegate = self
        viewController.view.addSubview(numberOfHoursPicker)

        // Add options
        let edditRadiusAlert = UIAlertController(title: "Repeat Interval", message: nil, preferredStyle: .alert)
        edditRadiusAlert.setValue(viewController, forKey: "contentViewController")
        edditRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            self.addAlertRepeatInterval.text = self.repeatIntervalHours
        }))
           
        edditRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present alert
        self.present(edditRadiusAlert, animated: true)
    }
    
    func alertEditLabel ()  {
        let alertController = UIAlertController(title: "Label this Alert", message: nil, preferredStyle: .alert)
        
        // Add Ok (Submit) Option and info destination
        alertSubmit = UIAlertAction(title: "Done", style: .default, handler: { [weak alertController] (_) in
            self.addAlertLabel.text = alertController?.textFields![0].text
        })
        
        // Add Cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Ok button starts as not enabled
        alertSubmit!.isEnabled = false
        
        // Add the text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Add a Custom Label"
            
            // Add listener to text field (when empty)
            textField.addTarget(self, action: #selector(AddAlertTableViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        }
        
        // Grab the value from the text field
        alertController.addAction(alertSubmit!)
        alertController.addAction(cancelAction)
        
        // Show allert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertEditStartDate ()  {
        // Create and configure view controller
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 250)
        
        // Create and add data picker to view controller
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        datePicker.datePickerMode = .date
        viewController.view.addSubview(datePicker)
        
        // Add options
        let edditRadiusAlert = UIAlertController(title: "Starting Date", message: nil, preferredStyle: .alert)
        edditRadiusAlert.setValue(viewController, forKey: "contentViewController")
        edditRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            self.addAlertStartDate.text = self.getDataFormatedAsString(datePicker.date, "dd/MM/yyyy")
        }))
            
        edditRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present alert
        self.present(edditRadiusAlert, animated: true)
    }
    
    func alertEditEndDate () {
        // Create and configure view controller
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 250)

        // Create and add data picker to view controller
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        datePicker.datePickerMode = .date
        viewController.view.addSubview(datePicker)

        // Add options
        let edditRadiusAlert = UIAlertController(title: "Ending Date", message: nil, preferredStyle: .alert)
        edditRadiusAlert.setValue(viewController, forKey: "contentViewController")
        edditRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            self.addAlertEndDate.text = self.getDataFormatedAsString(datePicker.date, "dd/MM/yyyy")
        }))
          
        edditRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present alert
        self.present(edditRadiusAlert, animated: true)
    }
    
    
    // MARK: - Data Picker
    
    // Function executed by the listener
    @objc func dateChanged (){
        selectedDate = self.addAlertDatePicker.date
    }
    
    // Translate UIDataPiker into  Date
    func  getDataFormatedAsString(_ origianalDate: Date, _ format: String) -> String {
        // Format to usable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        // Return the Date
        return dateFormatter.string(from: origianalDate)
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
    
    // MARK: - Interactions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.destination is MedicationInclusionTableViewController
        {
            let vc = segue.destination as? MedicationInclusionTableViewController
            vc?.medications2 = self.medications
            
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
            return
        }
        
        okAddAlert(sender as Any)
    }
}
