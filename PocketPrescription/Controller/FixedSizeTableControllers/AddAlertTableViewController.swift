//
//  AddAlertTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 11/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class AddAlertTableViewController: UITableViewController,  UIPickerViewDelegate, UIPickerViewDataSource{
    
    //Outlets
    
    @IBOutlet weak var addAlertImportanceLevel: UILabel!
    @IBOutlet weak var addAlertRepeatInterval: UILabel!
    @IBOutlet weak var addAlertLabel: UITextField!
    @IBOutlet weak var addAlertEndDate: UILabel!
    @IBOutlet weak var addAlertMedicationList: UILabel!
    @IBOutlet var addAlertOkButton: UIBarButtonItem!
    
    let referenceDate = Date()
    // Fields to take into acount
    var addAlertRepeatIntervalText: String = "" {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = ( !self.addAlertLabelText.isEmpty &&
                !(self.addAlertEndDateText == referenceDate) &&
                !self.addAlertMedicationListText.isEmpty ) ? true : false
        }
    }
    var addAlertLabelText: String = "" {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = (!self.addAlertRepeatIntervalText.isEmpty && !newValue.isEmpty &&
                !(self.addAlertEndDateText == referenceDate) &&
                !self.addAlertMedicationListText.isEmpty ) ? true : false
        }
    }
    var addAlertEndDateText: Date = Date() {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = (!self.addAlertRepeatIntervalText.isEmpty && !self.addAlertLabelText.isEmpty &&
                !(newValue == referenceDate) &&
                !self.addAlertMedicationListText.isEmpty ) ? true : false
        }
    }
    var addAlertMedicationListText: String = "" {
        willSet(newValue) {
            self.addAlertOkButton.isEnabled = (!self.addAlertRepeatIntervalText.isEmpty && !self.addAlertLabelText.isEmpty &&
                !(self.addAlertEndDateText == referenceDate) &&
                !newValue.isEmpty ) ? true : false
        }
    }
    var addAlertImportanceLevelText: Int = 1
    
    // Variables
    let ENTITIE: String = "Alert"
    var alertInfo: NSManagedObject?
    var medications: [NSManagedObject] = []
    
    // Data Piker
    var importanceLevel: Int = 1
    var repeatIntervalHours: String?
    var numberOfHoursPicker: UIPickerView!
    var importanceLevelPiker: UIPickerView!
    
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
        
        addAlertLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // Limit Amount of Colls
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        switch indexPath.section{
            case 1:
                switch indexPath.row {
                // Repeat
                case 0:
                    self.alertEditRepeat()
                // Label
                case 1:
                    self.alertEditEndDate()
                default:
                    return
                }
            case 2:
                self.alertEditImportanceLevel()
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
        if(pickerView == numberOfHoursPicker){
            let numberOfHoursInADay = 24
            return numberOfHoursInADay
        }else{
            let levelsOfImportance = 5
            return levelsOfImportance
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == numberOfHoursPicker){
            return "\(row + 1) Hour(s)"
        }else{
            return "\(row + 1)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == numberOfHoursPicker){
            self.repeatIntervalHours = "\(row + 1) Hour(s)"
        }else{
            self.importanceLevel = row + 1
        }
    }
    
    // MARK: - Fields
    func alertEditRepeat ()  {
        // Create and configure view controller
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 250)

        // Create and add data picker to view controller
        numberOfHoursPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
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
    
    func alertEditImportanceLevel (){
        // Create and configure view controller
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 250)

        // Create and add data picker to view controller
        importanceLevelPiker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        importanceLevelPiker.delegate = self
        viewController.view.addSubview(importanceLevelPiker)

        // Add options
        let edditRadiusAlert = UIAlertController(title: "Level of Importance", message: nil, preferredStyle: .alert)
        edditRadiusAlert.setValue(viewController, forKey: "contentViewController")
        edditRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            self.addAlertImportanceLevelText = self.importanceLevel
            self.addAlertImportanceLevel.text = "\(self.importanceLevel)"
        }))
        edditRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present alert
        self.present(edditRadiusAlert, animated: true)
    }
    
    @objc func textFieldChanged(_ sender: Any) {
        self.addAlertLabelText = self.addAlertLabel.text!
    }
    
    // MARK: - Data Pickers
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
        
        self.addAlertImportanceLevel.text = "\(self.alertInfo!.value(forKey: "importanceLevel") as? Int ?? 0)"
        self.addAlertImportanceLevelText = self.alertInfo!.value(forKey: "importanceLevel") as? Int ?? 0
        
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
    
    func editAlert() {
        alertInfo!.setValue(true, forKey: "state")
        alertInfo!.setValue(self.addAlertLabelText, forKey: "name")
        alertInfo!.setValue(self.addAlertRepeatIntervalText, forKey: "repeatInterval")
        alertInfo!.setValue(self.addAlertImportanceLevelText as Int, forKey: "importanceLevel")
        alertInfo!.setValue(self.addAlertEndDateText, forKey: "endDate")
        alertInfo!.setValue(NSSet(array: self.medications), forKey: "medications")
        
        self.saveToCoreData()
    }
    
    func createAlert() {
        let newAlert = NSManagedObject(entity: entity!, insertInto: context)
        let randomInt = Int.random(in: 0..<100)
        let identefier = "alert_\(self.addAlertLabelText)_\(randomInt)"
        let description = "Remeber to take: \(self.addAlertMedicationListText)"
        
        //Save info to Core Data
        newAlert.setValue(identefier, forKey: "identifier")
        newAlert.setValue(true, forKey: "state")
        newAlert.setValue(self.addAlertLabelText, forKey: "name")
        newAlert.setValue(self.addAlertRepeatIntervalText, forKey: "repeatInterval")
        newAlert.setValue(self.addAlertImportanceLevelText, forKey: "importanceLevel")
        newAlert.setValue(self.addAlertEndDateText, forKey: "endDate")
        newAlert.setValue(NSSet(array: self.medications), forKey: "medications")
        
        // Transform the string with the hours into hours in seconds
        let delimiter = " ";
        let numberOfHours = Int((self.addAlertRepeatIntervalText.components(separatedBy: delimiter)[0] ))!
        let hoursInSeconds = numberOfHours * 60 * 60
        
        // Create Notification
        Notification.shared.createNotification(identefier, self.addAlertLabelText, self.addAlertRepeatIntervalText, hoursInSeconds ,description)
        
        self.saveToCoreData()
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
            self.editAlert()
            return
        }
        self.createAlert()
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
