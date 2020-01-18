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

class HomePageViewController: UIViewController, CLLocationManagerDelegate {

    // Outlets
    @IBOutlet var homeMedicationCount: UILabel!
    @IBOutlet var homeAlertCount: UILabel!
    @IBOutlet var homePersonOfTrustCount: UILabel!
    
    // Constant
    var userInformation: NSManagedObject?
    let locationManager = CLLocationManager()
    let ENTITIES: [String] = ["Alert", "Medication", "PersonOfTrust","Person"]
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIES[3], in: context)
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadOverviewInformation()
        self.userInformation = manageUser()
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        locationManager.distanceFilter = 100
        
        // acedes a localização
        let latitude = self.userInformation!.value(forKey: "latitude") as? Double ?? 0
        let longitude = self.userInformation!.value(forKey: "longitude") as? Double ?? 0
        
        if latitude == 0 {
            let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(latitude, longitude), radius: 100, identifier: "Geofence")
           
            geoFenceRegion.notifyOnEntry = false
            geoFenceRegion.notifyOnExit = true
            
            locationManager.startMonitoring(for: geoFenceRegion)
        }
        
    }
    
    func manageUser() -> NSManagedObject {
        var user: NSManagedObject?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIES[3])
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            // Se não existe um utilizador cria
            if(result.count == 0){
                user = NSManagedObject(entity: entity!, insertInto: context)
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
    
    func loadOverviewInformation() {
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
    
    func saveToCoreData(){
        do {
          try context.save()
         } catch {
          print("Failed saving")
        }
    }
}
