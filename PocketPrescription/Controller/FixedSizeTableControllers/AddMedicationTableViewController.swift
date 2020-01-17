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

class AddMedicationTableViewController: UITableViewController {
    
    @IBOutlet weak var nameAddMedication: UITextField!
    @IBOutlet weak var categoryAddMedication: UITextField!
    @IBOutlet var medicationImgButton: UIView!
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
    
    var profileImageViewWidth: CGFloat = 100
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = profileImageViewWidth / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
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
        
        view.addSubview(profileImageView)
        
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
    // MARK: - Functionality
    
    @IBAction func okAddMedication(_ sender: Any) {
        if(self.edditMode){
            medicationInfo!.setValue(self.nameAddMedicationText, forKey: "name")
            medicationInfo!.setValue(self.categoryAddMedicationText, forKey: "category")
            
            self.saveToCoreData()
            return
        }
        
        let newMedication = NSManagedObject(entity: entity!, insertInto: context)
        
        //default is wrong
        newMedication.setValue("testing", forKey: "infoDescription")
        newMedication.setValue(nameAddMedication.text , forKey: "name")
        newMedication.setValue(categoryAddMedication.text , forKey: "category")
        
        saveToCoreData()
    }
    
    func inicializeFields(){
        self.nameAddMedication.text = self.medicationInfo!.value(forKey: "name") as? String ?? "Detail"
        self.nameAddMedicationText = self.medicationInfo!.value(forKey: "name") as? String ?? "Detail"
        self.categoryAddMedication.text = self.medicationInfo!.value(forKey: "category") as? String ?? "Error"
        self.categoryAddMedicationText = self.medicationInfo!.value(forKey: "category") as? String ?? "Error"
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
            profileImageView.image = editImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
