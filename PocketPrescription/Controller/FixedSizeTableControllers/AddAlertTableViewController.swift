//
//  AddAlertTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 11/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class AddAlertTableViewController: TableViewControllerWithNotifications, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Outlets
    @IBOutlet weak var addAlertDatePicker: UIDatePicker!
    @IBOutlet weak var addAlertRepeatInterval: UILabel!
    @IBOutlet weak var addAlertLabel: UILabel!
    @IBOutlet weak var addAlertStartDate: UILabel!
    @IBOutlet weak var addAlertEndDate: UILabel!
    @IBOutlet weak var addAlertMedicationList: UILabel!
    @IBOutlet var addAlertOkButton: UIBarButtonItem!
    
    let referenceDate = Date()
    // Fields to take into acount
    var addAlertRepeatIntervalText: String = "" {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = ( !self.addAlertLabelText.isEmpty &&
                !(self.addAlertStartDateText == referenceDate) &&
                !(self.addAlertEndDateText == referenceDate) &&
                !self.addAlertMedicationListText.isEmpty ) ? true : false
        }
    }
    var addAlertLabelText: String = "" {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = (!self.addAlertRepeatIntervalText.isEmpty && !newValue.isEmpty &&
                !(self.addAlertStartDateText == referenceDate) &&
                !(self.addAlertEndDateText == referenceDate) &&
                !self.addAlertMedicationListText.isEmpty ) ? true : false
        }
    }
    var addAlertStartDateText: Date = Date() {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = (!self.addAlertRepeatIntervalText.isEmpty && !self.addAlertLabelText.isEmpty &&
                !(newValue == referenceDate)  &&
                !(self.addAlertEndDateText == referenceDate) &&
                !self.addAlertMedicationListText.isEmpty ) ? true : false
        }
    }
    var addAlertEndDateText: Date = Date() {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = (!self.addAlertRepeatIntervalText.isEmpty && !self.addAlertLabelText.isEmpty &&
                !(self.addAlertStartDateText == referenceDate) &&
                !(newValue == referenceDate) &&
                !self.addAlertMedicationListText.isEmpty ) ? true : false
        }
    }
    var addAlertMedicationListText: String = "" {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = (!self.addAlertRepeatIntervalText.isEmpty && !self.addAlertLabelText.isEmpty &&
                !(self.addAlertStartDateText == referenceDate) &&
                !(self.addAlertEndDateText == referenceDate) &&
                !newValue.isEmpty ) ? true : false
        }
    }
    
    // Variables
    let ENTITIE: String = "Alert"
    var alertInfo: NSManagedObject?
    var medications: [NSManagedObject] = []
    
    var selectedDate: Date!
    var alertSubmit: UIAlertAction?
    var repeatIntervalHours: String?
    
    // View will be used in what way
    var edditMode: Bool = false
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)
    
    // MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.edditMode){
            self.inicializeFields()
        }
        
        // Inicialize Date
        selectedDate = self.addAlertDatePicker.date
        addAlertOkButton.isEnabled = true
        
        // Add Listener to the Date Picker
        addAlertDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

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
        return "\(row + 1) Hour(s)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.repeatIntervalHours = "\(row + 1) Hour(s)"
    }
    
    // MARK: - Fields
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
            //treat null
            self.addAlertRepeatIntervalText = self.repeatIntervalHours == nil ? "1 Hours" : self.repeatIntervalHours ?? "1 Hours"
            self.addAlertRepeatInterval.text = self.repeatIntervalHours == nil ? "1 Hours" : self.repeatIntervalHours
        }))
        edditRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present alert
        self.present(edditRadiusAlert, animated: true)
    }
    
    func alertEditLabel ()  {
        let alertController = UIAlertController(title: "Label this Alert", message: nil, preferredStyle: .alert)
        
        // Add Ok (Submit) Option and info destination
        alertSubmit = UIAlertAction(title: "Done", style: .default, handler: { [weak alertController] (_) in
            self.addAlertLabelText = alertController?.textFields![0].text ?? "error"
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
            self.addAlertStartDateText = datePicker.date
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
            self.addAlertEndDateText = datePicker.date
            self.addAlertEndDate.text = self.getDataFormatedAsString(datePicker.date, "dd/MM/yyyy")
        }))
          
        edditRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present alert
        self.present(edditRadiusAlert, animated: true)
    }
    
    // When the text field dosn´t have anny text the Ok button is not available
    @objc func textFieldDidChange(sender: UITextField){
        if sender.text == "" {
            alertSubmit!.isEnabled = false
        }else{
            alertSubmit!.isEnabled = true
        }
    }
    
    // MARK: - Data Pickers
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
        
    // MARK: - Functionality
    func inicializeFields(){
        self.addAlertLabel.text = self.alertInfo!.value(forKey: "name") as? String ?? "Detail"
        self.addAlertLabelText = self.alertInfo!.value(forKey: "name") as? String ?? "Detail"
        self.addAlertRepeatInterval.text = self.alertInfo!.value(forKey: "repeatInterval") as? String ?? "1 Hours(s)"
        self.addAlertRepeatIntervalText = self.alertInfo!.value(forKey: "repeatInterval") as? String ?? "1 Hour(s)"
        self.addAlertStartDate.text = self.getDataFormatedAsString(alertInfo!.value(forKey: "startDate") as! Date, "dd/MM/yyyy")
        self.addAlertStartDateText = self.alertInfo!.value(forKey: "startDate") as! Date
        self.addAlertEndDate.text = self.getDataFormatedAsString(alertInfo!.value(forKey: "endDate") as! Date, "dd/MM/yyyy")
        self.addAlertEndDateText = self.alertInfo!.value(forKey: "endDate") as! Date
        
        var medicationString = ""
        let medications = self.alertInfo!.value(forKey: "medications") as! NSSet
        for medication in medications {
            self.medications.append(medication as! NSManagedObject)
            medicationString += ((medication as AnyObject).value(forKey: "name") as? String  ?? "") + " "
        }
        
        self.addAlertMedicationList.text = medicationString
        self.addAlertMedicationListText = medicationString
    }
    
    func saveToCoreData(){
       do {
          try context.save()
         } catch {
          print("Failed saving")
       }
    }
    
    // MARK: - Interactions
    @IBAction func okAddAlert(_ sender: Any) {
        // Eddit
        if(self.edditMode){
            alertInfo!.setValue(true, forKey: "state")
            alertInfo!.setValue(self.addAlertLabelText, forKey: "name")
            alertInfo!.setValue(self.addAlertRepeatIntervalText, forKey: "repeatInterval")
            alertInfo!.setValue(self.addAlertStartDateText, forKey: "startDate")
            alertInfo!.setValue(self.addAlertEndDateText, forKey: "endDate")
            alertInfo!.setValue(NSSet(array: self.medications), forKey: "medications")
            
            self.saveToCoreData()
            return
        }
        
        // Create Notification
        self.createNotification(addAlertLabel.text ?? "Something went Wrong", self.addAlertRepeatInterval.text ?? "No interval Defined", "Remeber to take: \(addAlertMedicationList.text ?? "Medication Missing")")
        

        let newAlert = NSManagedObject(entity: entity!, insertInto: context)
        
        //Save info to Core Data
        newAlert.setValue(true, forKey: "state")
        newAlert.setValue(self.addAlertLabelText, forKey: "name")
        newAlert.setValue(self.addAlertRepeatIntervalText, forKey: "repeatInterval")
        newAlert.setValue(self.addAlertStartDateText, forKey: "startDate")
        newAlert.setValue(self.addAlertEndDateText, forKey: "endDate")
        newAlert.setValue(NSSet(array: self.medications), forKey: "medications")
        
        self.saveToCoreData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.destination is MedicationInclusionTableViewController
        {
            let addOrSubtractMedicationVC = segue.destination as! MedicationInclusionTableViewController
            addOrSubtractMedicationVC.medicationsSelected = self.medications
            addOrSubtractMedicationVC.callback = { (medication, state) in
                let currentMedicationText = self.addAlertMedicationList.text ?? ""
                let medicationName = medication.value(forKey: "name") as? String  ?? ""
                
                if state == true {
                    // Append to last spot
                    self.medications.append(medication)
                    self.addAlertMedicationListText = currentMedicationText + " " + medicationName
                    self.addAlertMedicationList.text = currentMedicationText + " " + medicationName
                }else{
                    // Remove filterd object
                    self.medications = self.medications.filter{ $0 != medication }
                    self.addAlertMedicationListText = currentMedicationText.replacingOccurrences(of: medicationName, with: "")
                    self.addAlertMedicationList.text = currentMedicationText.replacingOccurrences(of: medicationName, with: "")
                }
            }
            return
        }
        
        if segue.destination is AlertTableViewController
        {
            self.okAddAlert(sender as Any)
            return
        }
    }
}
