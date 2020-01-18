//
//  ApiAddMedicationViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 17/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class ApiAddMedicationViewController: UIViewController {
    
    let restApi: String = "https://www.mocky.io/v2/"
    
    let ENTITIE: String = "Medication"
    var medications: [NSManagedObject] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)


    override func viewDidLoad() {
        super.viewDidLoad()
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
                    let newMedication = NSManagedObject(entity: entity!, insertInto: context)
                    
                    if (med["img"] as? String) != nil {
                        newMedication.setValue(med["img"] as! String , forKey: "image")
                    }
                    newMedication.setValue(med["name"] as? String ?? "Not Found", forKey: "name")
                    newMedication.setValue(med["category"] as? String ?? "Not Found", forKey: "category")
                    newMedication.setValue(med["intervaloMedicacaoHoras"] as? String ?? "Not Found", forKey: "repeatIntervalHours")
                    newMedication.setValue(med["description"] as? String ?? "Not Found"  , forKey: "infoDescription")
                    
                    groupOfMedications.append(newMedication)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return groupOfMedications
    }

}
