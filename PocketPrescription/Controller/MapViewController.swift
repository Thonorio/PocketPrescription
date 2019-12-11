//
//  MapViewController.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 05/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func segmentedControl(_ sender: Any) {
    
    }
    
    let locationManager = CLLocationManager()
    let regionMeters: Double = 3000
    let searchRadius: CLLocationDistance = 3000
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //default is wrong
        checkLocationServices()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "pharmacy"
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            self.savePharmacys(response!.mapItems)
            
            for item in response!.mapItems {
                let aux = MKPointAnnotation()
                aux.title = item.name
                print("teste")
                aux.coordinate = CLLocationCoordinate2D(latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                self.mapView.addAnnotation(aux)
                
            }
        })
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func savePharmacys(_ pharmacys: [MKMapItem]){
        let context = appDelegate.persistentContainer.viewContext
       
        for pharmacy in pharmacys {
            let pharmacyEntity = NSEntityDescription.entity(forEntityName: "Pharmacy", in: context)!
            let newPharmacy = NSManagedObject(entity: pharmacyEntity, insertInto: context)
            newPharmacy.setValue(pharmacy.name, forKey: "name")
        }
        
        do {
            try context.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
                mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
           
        }else{
            
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()

        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
