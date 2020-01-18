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
    var userInformation: NSManagedObject?
    
    var mapDataReponse: Any?
    let regionMeters: Double = 3000
    let locationManager = CLLocationManager()
    
    // Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext! = appDelegate.persistentContainer.viewContext
    lazy var entity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load User
        self.userInformation = manageUser()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let latitude = self.userInformation!.value(forKey: "latitude") as? Double ?? 0
        let longitude = self.userInformation!.value(forKey: "longitude") as? Double ?? 0
        
        if latitude != 0 && longitude != 0
        {
            self.populateMap(latitude, longitude)
        }
    }
    
    func populateMap(_ latitude: Double, _ longitude: Double) {
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        self.mapView.delegate = self
        mapView.removeOverlays(mapView.overlays)
        
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geofence1")
        locationManager.startMonitoring(for: region)
        
        // Adition of the circle
        let circle = MKCircle(center: coordinate, radius: region.radius)
        self.mapView.addOverlay(circle)
        
        // Center Screen
        self.centerViewOnUserLocation(coordinate)
    }
    
    @IBAction func addRegion(_ sender: Any) {
        guard let longPress = sender as? UILongPressGestureRecognizer else { return }
        let touchLocation = longPress.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        self.mapView.delegate = self
        self.mapView.removeOverlays(mapView.overlays)
        
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geofence")
        
        let circle = MKCircle(center: coordinate, radius: region.radius)
        self.mapView.addOverlay(circle)
        
        locationManager.startMonitoring(for: region)
        print(coordinate.latitude)
        print(coordinate.longitude)
        self.saveUserHouse(coordinate.latitude,coordinate.longitude)
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
    
    func saveUserHouse(_ latitude: CLLocationDegrees,_ longitude: CLLocationDegrees){
        userInformation!.setValue(latitude, forKey: "latitude")
        userInformation!.setValue(longitude , forKey: "longitude")
        self.saveToCoreData()
    }
    
    func centerViewOnUserLocation(_ coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: - Core Data
    func manageUser() -> NSManagedObject {
        var user: NSManagedObject?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITIE)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            // Se não existe um utilizador cria
            if(result.count == 0){
                return NSManagedObject(entity: entity!, insertInto: context)
            }
            user = result[result.count - 1] as? NSManagedObject
            saveToCoreData()
            
            
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
}
    
    
extension DefineHomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
    }
}

