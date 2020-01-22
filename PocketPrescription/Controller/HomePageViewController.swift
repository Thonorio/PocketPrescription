//
//  HomePageViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 17/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import MessageUI

class HomePageViewController: UIViewController, CLLocationManagerDelegate {

    // Outlets
    @IBOutlet var homeMedicationCount: UILabel!
    @IBOutlet var homeAlertCount: UILabel!
    @IBOutlet var homePersonOfTrustCount: UILabel!
    @IBOutlet var homeView: UIView!
    
    // Constant
    var userInformation: NSManagedObject?
    let locationManager = CLLocationManager()
    let ENTITIES: [String] = ["Alert", "PersonOfTrust"]
    let ENTITIE_MEDICATION = "Medication"
    let ENTITIE_PERSON = "Person"
    lazy var entitie = NSEntityDescription.entity(forEntityName: ENTITIE_PERSON, in: context)
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Not at all optimized (path before delivery)
        self.loadMedicationInformation()
        self.loadOverviewInformation()
        self.userInformation = manageUser()
        inicializeTrackin()
    }
    override func viewDidAppear(_ animated: Bool) {
        // Not at all optimized (path before delivery)
        self.loadMedicationInformation()
        self.loadOverviewInformation()
    }
    
    func inicializeTrackin(){
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        locationManager.distanceFilter = 100
        
        // access home location
        let latitude = self.userInformation!.value(forKey: "latitude") as? Double ?? 0
        let longitude = self.userInformation!.value(forKey: "longitude") as? Double ?? 0
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(latitude, longitude), radius: 100, identifier: "Geofence")
        
        geoFenceRegion.notifyOnEntry = false
        geoFenceRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: geoFenceRegion)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func manageUser() -> NSManagedObject {
        var user: NSManagedObject?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE_PERSON)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            // Se não existe um utilizador cria
            if(result.count == 0){
                user = NSManagedObject(entity: entitie!, insertInto: context)
                user!.setValue("Default Name", forKey: "name")
                user!.setValue("Default Email", forKey: "email")

                saveToCoreData()
                
            }else{
                user = result[result.count - 1] as? NSManagedObject
            }
            
        } catch {
            print("Failed")
        }
        return user!
    }
    
    func loadMedicationInformation() {
        var request: NSFetchRequest<NSFetchRequestResult>
        var result = 0
            request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE_MEDICATION)
            request.returnsObjectsAsFaults = false
            do {
                result = try context.fetch(request).count
            } catch {
                print("Failed")
            }
        self.homeMedicationCount.text = "\(result)"
    }
    
    func loadOverviewInformation() {
        var request: NSFetchRequest<NSFetchRequestResult>
        var result = [Int]()
        var i = 0
        let predicate = NSPredicate(format: "state != %@", "true")
        for entitie in ENTITIES {
            request = NSFetchRequest<NSFetchRequestResult>(entityName: entitie)
            request.returnsObjectsAsFaults = false
            request.predicate = predicate
            do {
                result.append(try context.fetch(request).count)
                i += 1
            } catch {
                print("Failed")
            }
        }
        self.homeAlertCount.text = "\(result[0])"
        self.homePersonOfTrustCount.text = "\(result[1])"
    }
    
    func saveToCoreData(){
        do {
          try context.save()
         } catch {
          print("Failed saving")
        }
    }
}
