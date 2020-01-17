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
    let ENTITIES: [String] = ["Alert", "Medication", "PersonOfTrust","Person"]
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    
    let locationManager = CLLocationManager()
    var utilizador: Person // é preciso inicializar?
    let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
    let utilizador = Card(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
// qual deles usar ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        locationManager.distanceFilter = 100
        
        // fazer isto, mas há a hipótesse de o user n ter localização
        if utilizador.latitude == 0 { //se n\ao existir este campo n precisa de monotorizar VER SE ISTO FUNCIONA
            let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(utilizador.latitude, utilizador.longitude), radius: 100, identifier: "Geofence")
            // aqui mudar pela localizaçao do utilizador
            
            geoFenceRegion.notifyOnEntry = false
            geoFenceRegion.notifyOnExit = true
            
            locationManager.startMonitoring(for: geoFenceRegion)
        }
        
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
                let resultPerson = try context.fetch(request)
                //se for do tipo person, guardar os dados
                if resultPerson. == "Person" {
                    self.utilizador = (resultPerson as? [NSManagedObject])! // as? Person
                }
            } catch {
                print("Failed")
            }
        }
        self.homeAlertCount.text = "\(result[0])"
        self.homeMedicationCount.text = "\(result[1])"
        self.homePersonOfTrustCount.text = "\(result[2])"
    }
}
