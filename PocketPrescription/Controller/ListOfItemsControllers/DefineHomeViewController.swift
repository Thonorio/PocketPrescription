//
//  DefineHomeViewController.swift
//  PocketPrescription
//
//  Created by Xavier Santos De Oliveira on 17/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications
import CoreData



class DefineHomeViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // Variables
    let ENTITIE: String = "Person"
    var person: [NSManagedObject] = []
    let locationManager = CLLocationManager()
    let regionMeters: Double = 3000
    var mapDataReponse: Any?
    var userInformation: NSManagedObject?
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)

    // Core Data
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.userInformation = manageUser()
        self.loadData()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if self.userInformation!.value(forKey: "latitude") as? Double
 != nil && self.userInformation!.value(forKey: "longitude") as? Double != nil && self.userInformation!.value(forKey: "latitude") as? Double != 0 && self.userInformation!.value(forKey: "longitude") as? Double != 0
        {
        self.populateMap() // o utilizador já tem casa defenida, tenho de desenhar no mapa, não sei se estou a usar a variável certa mas tem de ser do load data
        //fazer o circulo caso haja coordenadas

        }
    }

        
    
    
    @IBAction func addRegion(_ sender: Any) {

        guard let longPress = sender as? UILongPressGestureRecognizer else { return }
        let touchLocation = longPress.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            //meter o coordinate no user e escrever no campo, fazer load
                        print(coordinate)
            saveUserHouse(coordinate.latitude,coordinate.longitude)
            self.mapView.delegate = self
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geofence")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinate, radius: region.radius)
        self.mapView.addOverlay(circle)
    }
    
 
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func populateMap() {

        let coordinate = CLLocationCoordinate2DMake(self.userInformation!.value(forKey: "latitude") as? Double ?? 0,self.userInformation!.value(forKey: "longitude") as? Double ?? 0)
        print(coordinate)
        self.mapView.delegate = self
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geofence1")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinate, radius: region.radius)
        self.mapView.addOverlay(circle)
        //mapView.userTrackingMode = .follow
        centerViewOnUserLocation(coordinate)
    }
    
func saveUserHouse(_ latitude: CLLocationDegrees,_ longitude: CLLocationDegrees){

    userInformation!.setValue(latitude, forKey: "latitude")
    userInformation!.setValue(longitude , forKey: "longitude")
    saveToCoreData()
    print(userInformation!)
}
    
    func centerViewOnUserLocation(_ coordinate: CLLocationCoordinate2D){
       let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
           mapView.setRegion(region, animated: true)
       
   }
    
func manageUser() -> NSManagedObject {
    var user: NSManagedObject?
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)
    request.returnsObjectsAsFaults = false
    
    do {
        let result = try context.fetch(request)
        // Se não existe um utilizador cria
        if(result.count == 0){
            user = NSManagedObject(entity: entity!, insertInto: context)
            // primeiro campo é o valor podes meter uma variavel (eventualmente será dado pela pagina de "Lgin") e a segunda ver (forkey) é o nome dado o campo no Core Data
            user!.setValue("Default Name", forKey: "name")
            user!.setValue("Default Email", forKey: "email")
            user!.setValue(999999999, forKey: "phoneNumber")
            saveToCoreData()

            
        }else{
            user = result[result.count - 1] as? NSManagedObject
            saveToCoreData()

        }
        
    } catch {
        print("Failed")
    }
    return user!
}
    
func saveToCoreData(){
    do {
      try context.save()
     } catch {
      print("Failed saving")
    }
}
    
func loadData(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        
        // forcing it to be casted to NSManagedObject
        person = (result as? [NSManagedObject])!

    } catch {
        print("Failed")
    }
}
    
}

extension DefineHomeViewController: CLLocationManagerDelegate {

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    mapView.showsUserLocation = true
}
}

