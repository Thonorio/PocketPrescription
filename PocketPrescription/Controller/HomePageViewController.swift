//
//  HomePageViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 17/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class HomePageViewController: UIViewController {

    // Outlets
    @IBOutlet var homeMedicationCount: UILabel!
    @IBOutlet var homeAlertCount: UILabel!
    @IBOutlet var homePersonOfTrustCount: UILabel!
    
    // Constant
    let ENTITIES: [String] = ["Alert", "Medication", "PersonOfTrust"]
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.loadData()
    }
    
    func loadData() {
        var request: NSFetchRequest<NSFetchRequestResult>
        var result = [Int]()
        var i = 0
        for entitie in ENTITIES {
            request = NSFetchRequest<NSFetchRequestResult>(entityName: entitie)
            request.returnsObjectsAsFaults = false
            do {
                result.append(try context.fetch(request).count)
                i += 1
            } catch {
                print("Failed")
            }
        }
        self.homeAlertCount.text = "\(result[0])"
        self.homeMedicationCount.text = "\(result[1])"
        self.homePersonOfTrustCount.text = "\(result[2])"
    }
}
