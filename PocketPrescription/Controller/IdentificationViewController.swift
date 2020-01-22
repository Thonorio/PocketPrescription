//
//  IdentificationViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 19/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class IdentificationViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet var identificationSubmitButton: UIButton!
    @IBOutlet var identificationName: UITextField!
    @IBOutlet var identificationEmail: UITextField!
    
    var identificationNameText: String = "" {
        willSet(newValue) {
            if(self.identificationEmailText.isEmpty || newValue.isEmpty || !isValidEmail(self.identificationEmailText)){
                self.identificationSubmitButton.isEnabled = false
                identificationSubmitButton.alpha = 0.5;
            }else{
                self.identificationSubmitButton.isEnabled = true
                identificationSubmitButton.alpha = 1;
            }
        }
    }
    var identificationEmailText: String = "" {
        willSet(newValue) {
            if(self.identificationNameText.isEmpty || newValue.isEmpty || !isValidEmail(newValue)){
                self.identificationSubmitButton.isEnabled = false
                identificationSubmitButton.alpha = 0.5;
            }else{
                self.identificationSubmitButton.isEnabled = true
                identificationSubmitButton.alpha = 1;
            }
        }
    }
    
    var person: NSManagedObject!
    
    // Core Data
    let ENTITIE: String = "Person"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var entitie = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
        
        self.person = self.loadOverviewInformation()
        self.identificationName.delegate = self
        self.identificationEmail.delegate = self
        self.identificationName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.identificationEmail.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    // MARK: - TextFiled
    @objc func textFieldChanged(_ sender: Any) {
        self.identificationNameText = self.identificationName.text!
        self.identificationEmailText = self.identificationEmail.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - Core Data
       func loadOverviewInformation() -> NSManagedObject!{
           var personStored: NSManagedObject?
           let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)
           request.returnsObjectsAsFaults = false
           
           do {
               let fetchedInfo = try context.fetch(request) as? [NSManagedObject]
               if(fetchedInfo?.count == 0){
                   personStored = NSManagedObject(entity: entitie!, insertInto: context)
                   personStored!.setValue("Not Available", forKey: "name")
                   personStored!.setValue("Not Available", forKey: "email")
               }else{
                   personStored = fetchedInfo?[0]
               }
           } catch {
               personStored = NSManagedObject(entity: entitie!, insertInto: context)
           }
           return personStored
       }
       
       func saveToCoreData(){
           do {
             try context.save()
            } catch {
             print("Failed saving")
           }
       }
       
    
    // MARK: - Interactions
    @IBAction func identificationSubmit(_ sender: Any) {
        person.setValue(identificationNameText, forKey: "name")
        person.setValue(identificationEmailText, forKey: "email")
        performSegue(withIdentifier: "homePageViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           super.prepare(for: segue, sender: sender)
           saveToCoreData()
    }
        
}
