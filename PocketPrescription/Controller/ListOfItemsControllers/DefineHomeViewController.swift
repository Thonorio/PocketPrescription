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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mapDataReponse: Any?


    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.loadData()
        self.populateMap((person as? Person)!) // o utilizador já tem casa defenida, tenho de desenhar no mapa, não sei se estou a usar a variável certa mas tem de ser do load data
        //fazer o circulo caso haja coordenadas

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
    
    func populateMap(_ response: Person) {
        let coordinate = CLLocationCoordinate2DMake(response.latitude, response.longitude)
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geofence")
        mapView.removeOverlays(mapView.overlays)
        let circle = MKCircle(center: coordinate, radius: region.radius)
        self.mapView.addOverlay(circle)
    }
    
func saveUserHouse(_ latitude: CLLocationDegrees,_ longitude: CLLocationDegrees){
    let context = appDelegate.persistentContainer.viewContext

        let personEntity = NSEntityDescription.entity(forEntityName: ENTITIE, in: context)!
        let newPerson = NSManagedObject(entity: personEntity, insertInto: context)
        
            // por corrigir pois não posso criar 1 nova pessoa
        newPerson.setValue(latitude, forKey: "latitude")
        newPerson.setValue(longitude, forKey: "longitude")
    do {
        try context.save()
    } catch {
        print("Error saving: \(error)")
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

