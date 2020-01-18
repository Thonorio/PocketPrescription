//
//  APIMedicationTableViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 18/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class APIMedicationTableViewController: ListOfItemsTableViewController, MedicationInclusionTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate  {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var medicationInclusionTableView: UITableView!
    
    let restApi: String = "https://www.mocky.io/v2/"
    
    let ENTITIE: String = "Medication"
    var medications: [NSManagedObject] = []
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createWithApi()
        
        // Cell registation
        let nibName = UINib(nibName: "APIMedicationTableViewCell", bundle: nil)
        medicationInclusionTableView.dataSource = self
        medicationInclusionTableView.delegate = self
        medicationInclusionTableView.register(nibName, forCellReuseIdentifier: "aPIMedicationTableViewCell")
                       
        // Search Bar
        searchBar.delegate=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Refresh
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "aPIMedicationTableViewCell", for: indexPath) as? APIMedicationTableViewCell else {
            fatalError("The dequeued cell is not an instance of MedicationInclusionTableViewCell.")
        }
        
        // Atributes medication based on the index
        let medication = medications[indexPath.row]
        cell.medicationViewInit(medication)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Functionality
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        medications = self.searchInformation(textDidChange: searchText, ENTITIE)
        tableView.reloadData()
    }
    
    func createWithApi () {
           let endpoint = "5e21e2cb2f0000780077d995"
           let url = URL(string: "\(restApi)\(endpoint)")!
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           
           
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
       
               // Check if Error took place
               if let error = error {
                   print("Error took place \(error)")
                   return
               }
               
               // Read HTTP Response Status code
               if let response = response as? HTTPURLResponse {
                   print("Response HTTP Status code: \(response.statusCode)")
               }
               
               // Convert HTTP Response Data to a simple String
               if let data = data, let dataString = String(data: data, encoding: .utf8) {
                   self.medications = self.parseReponse(dataString)
               }
               
           }
           task.resume()
       }
       
    func parseReponse (_ response: String) -> [NSManagedObject] {
        
        var groupOfMedications: [NSManagedObject] = []
        let data = response.data(using: .utf8)!
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                let data = json["data"] as! [[String : AnyObject]]
                for med in data {
                    let newMedication = NSManagedObject(entity: entity!, insertInto: nil)
                    
                    if (med["img"] as? String) != nil {
                        newMedication.setValue(med["img"] as! String , forKey: "image")
                    }
                    newMedication.setValue(med["name"] as? String ?? "Not Found", forKey: "name")
                    newMedication.setValue(med["category"] as? String ?? "Not Found", forKey: "category")
                    newMedication.setValue(med["intervaloMedicacaoHoras"] as? String ?? "Not Found", forKey: "repeatIntervalHours")
                    newMedication.setValue(med["description"] as? String ?? "Not Found"  , forKey: "infoDescription")
                    
                    if !self.medications.contains(newMedication){
                        groupOfMedications.append(newMedication)
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return groupOfMedications
    }
    
    func apiMedicationAddToMedications(_ medication: NSManagedObject,_ medicationState: Bool ){
        if(medicationState == true){
            var newMedication = NSManagedObject(entity: entity!, insertInto: context)
            newMedication.setValue(medication.value(forKey: "name") as! String, forKey: "name")
            newMedication.setValue(medication.value(forKey: "category") as! String, forKey: "category")
            newMedication.setValue(medication.value(forKey: "repeatIntervalHours") as! String, forKey: "repeatIntervalHours")
            newMedication.setValue(medication.value(forKey: "infoDescription") as! String , forKey: "infoDescription")
            saveToCoreData()
        }else{
            //Remove Core Data
            context.delete(medication)
            saveToCoreData()
        }
    }
    
}
