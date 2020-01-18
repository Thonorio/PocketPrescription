//
//  AddMedicationTableViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 28/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import os
import MessageUI
import CoreData

class AddMedicationTableViewController: UITableViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameAddMedication: UITextField!
    @IBOutlet weak var categoryAddMedication: UITextField!
    @IBOutlet var medicationLevelOfImportance: UILabel!
    @IBOutlet var medicationRecommendedInterval: UILabel!
    @IBOutlet var medicationDescription: UITextView!
    @IBOutlet var medicationImgButton: UIView!
    @IBOutlet var medicationAddImgButon: UIButton!
    
    @IBOutlet weak var addMedicationOkButton: UIBarButtonItem!
    
    // Fields to take into acount
    var nameAddMedicationText: String = "" {
        willSet(newValue) {
            self.addMedicationOkButton.isEnabled = (!newValue.isEmpty && !self.categoryAddMedicationText.isEmpty ) ? true : false
        }
    }
    var categoryAddMedicationText: String = "" {
        willSet(newValue) {
            self.addMedicationOkButton.isEnabled = (!self.nameAddMedicationText.isEmpty && !newValue.isEmpty ) ? true : false
        }
    }
    var repeatIntervalHours: String?
    var levelOfImportante: Int = 0
    
    var profileImageViewWidth: CGFloat = 100
    
    // Variables
    let ENTITIE: String = "Medication"
    var medications: [NSManagedObject] = []

    // View will be used in what way
    var edditMode: Bool = false
    var medicationInfo: NSManagedObject?
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (edditMode){
            self.inicializeFields()
        }
        self.tableView.register(
            AddMedicationHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier:
                AddMedicationHeaderFooterView.reuseIdentifier
        )
        
        nameAddMedication.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        categoryAddMedication.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
        case 0:
            self.levelOfImportanceTapped()
        case 1:
            self.recommendedIntervalTapped()
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
        let levelsOfImportance = 5
        return levelsOfImportance
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.levelOfImportante = row + 1
    }
    
    // MARK: - Functionality
    func inicializeFields(){
        self.nameAddMedication.text = self.medicationInfo!.value(forKey: "name") as? String ?? "Detail"
        self.nameAddMedicationText = self.medicationInfo!.value(forKey: "name") as? String ?? "Detail"
        self.categoryAddMedication.text = self.medicationInfo!.value(forKey: "category") as? String ?? "Error"
        self.categoryAddMedicationText = self.medicationInfo!.value(forKey: "category") as? String ?? "Error"
        
        self.medicationLevelOfImportance.text = String(self.medicationInfo!.value(forKey: "importanceLevel") as! Int)
        self.repeatIntervalHours = self.medicationInfo!.value(forKey: "repeatIntervalHours") as? String ?? "Detail"
        self.medicationRecommendedInterval.text = self.medicationInfo!.value(forKey: "repeatIntervalHours") as? String ?? "Detail"
        self.medicationDescription.text = self.medicationInfo!.value(forKey: "infoDescription") as? String ?? "No Description Found"
        
        
      //  self.medicationAddImgButon = self.medicationInfo!.value(forKey: "category") as? String ?? "Error"
    }
    
    func levelOfImportanceTapped(){
        // Create and configure view controller
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 250)
        
        // Create and add data picker to view controller
        let numberOfHoursPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        numberOfHoursPicker.delegate = self
        viewController.view.addSubview(numberOfHoursPicker)
        
        // Add options
        let edditRadiusAlert = UIAlertController(title: "Level of Importance", message: nil, preferredStyle: .alert)
        edditRadiusAlert.setValue(viewController, forKey: "contentViewController")
        edditRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            self.medicationLevelOfImportance.text = String(self.levelOfImportante)
        }))
        edditRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present alert
        self.present(edditRadiusAlert, animated: true)
    }
    func recommendedIntervalTapped(){
        let alertController = UIAlertController(title: "Label this Alert", message: nil, preferredStyle: .alert)
        
        // Add Ok (Submit) Option and info destination
        let submit =  UIAlertAction(title: "Done", style: .default, handler: { [weak alertController] (_) in
            self.repeatIntervalHours = alertController?.textFields![0].text ?? "1 Hour(s)"
            self.medicationRecommendedInterval.text = alertController?.textFields![0].text ?? "1 Hour(s)"
        })
        
        // Add the text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "10 Hour(s)"
        }
        
        // Grab the value from the text field
        alertController.addAction(submit)
        
        // Show allert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func textFieldChanged(_ sender: Any) {
        self.nameAddMedicationText = self.nameAddMedication.text!
        self.categoryAddMedicationText = self.categoryAddMedication.text!
    }
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        self.showImagePikerControllerActionSheet()
    }
    
    // MARK: - Core Data
    func saveToCoreData(){
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    // MARK: - Interactions
    @IBAction func okAddMedication(_ sender: Any) {
        
        let description = self.medicationDescription.text.isEmpty ? "No Description Found" : self.medicationDescription.text
        
        if(self.edditMode){
            medicationInfo!.setValue((medicationAddImgButon.currentImage)!.pngData(), forKey: "image")
            medicationInfo!.setValue(self.nameAddMedicationText, forKey: "name")
            medicationInfo!.setValue(self.categoryAddMedicationText, forKey: "category")
            medicationInfo!.setValue(self.repeatIntervalHours, forKey: "repeatIntervalHours")
            medicationInfo!.setValue(self.levelOfImportante, forKey: "importanceLevel")
            medicationInfo!.setValue(description, forKey: "infoDescription")
            
            self.saveToCoreData()
            return
        }
        
        let newMedication = NSManagedObject(entity: entity!, insertInto: context)
        
        newMedication.setValue((medicationAddImgButon.currentImage)!.pngData(), forKey: "image")
        newMedication.setValue(self.nameAddMedicationText, forKey: "name")
        newMedication.setValue(self.categoryAddMedicationText, forKey: "category")
        newMedication.setValue(self.repeatIntervalHours, forKey: "repeatIntervalHours")
        newMedication.setValue(self.levelOfImportante, forKey: "importanceLevel")
        newMedication.setValue(description, forKey: "infoDescription")
        
        saveToCoreData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.okAddMedication(sender as Any)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
}

extension AddMedicationTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePikerControllerActionSheet(){
        let photoLibraryAction = UIAlertAction(title: "Chose from Galery", style: .default) { (action) in
            self.showImagePikerController(sourceType: .photoLibrary)
        }
        let camaraAction = UIAlertAction(title: "Take a Photo", style: .default) { (action) in
            self.showImagePikerController(sourceType: .camera)
        }
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Chose Medication Image", message: nil, actions: [photoLibraryAction, camaraAction, cancelaction])
    }
    
    func showImagePikerController(sourceType: UIImagePickerController.SourceType){
        let imagePikerController = UIImagePickerController()
        imagePikerController.delegate = self
        imagePikerController.allowsEditing = true
        imagePikerController.sourceType = sourceType
        present(imagePikerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            medicationAddImgButon.setImage(editImage, for: UIControl.State.normal)
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
        
            medicationAddImgButon.setImage(originalImage, for: UIControl.State.normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
