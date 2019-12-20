//
//  PharmacyViewController.swift
//  PocketPrescription
//
//  Created by Xavier Santos De Oliveira on 29/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData

class PharmacyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate{
    
   
    
    
    @IBOutlet var tableView: UIView!
    @IBOutlet var firstView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
 
    
    var pharmacys: [NSManagedObject] = []
        

        let locationManager = CLLocationManager()
        let regionMeters: Double = 3000
        let searchRadius: CLLocationDistance = 3000
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    @IBAction func switchViews(_ sender: UISegmentedControl){
         
         if sender.selectedSegmentIndex == 0{
             firstView.isHidden = false
             mapView.isHidden = true
         }else{
             firstView.isHidden = true
             mapView.isHidden = false
         }
     }

        override func viewDidLoad() {
              super.viewDidLoad()
            firstView.dataSource = self
            firstView.delegate = self
            firstView.register(UITableViewCell.self, forCellReuseIdentifier: "PharmacyViewCell")
            self.loadData()

            
             //default is wrong
            checkLocationServices()
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "pharmacy"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            
            search.start(completionHandler: {(response, error) in
                self.savePharmacys(response!.mapItems)
                self.loadData()
                
                for item in response!.mapItems {
                    let aux = MKPointAnnotation()
                    aux.title = item.name
                    
                    aux.coordinate = CLLocationCoordinate2D(latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                    self.mapView.addAnnotation(aux)
                }
            })
       
        }
        
        func setupLocationManager(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    
        func cleanPharmacys(_ context: NSManagedObjectContext){
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Pharmacy.fetchRequest()
            // Configure Fetch Request
            fetchRequest.includesPropertyValues = false

            do {
                let items = try context.fetch(fetchRequest) as! [NSManagedObject]

                for item in items {
                    context.delete(item)
                }

                // Save Changes
                try context.save()

            } catch {
                // Error Handling
                // ...
            }
        }
    
        func savePharmacys(_ pharmacys: [MKMapItem]){
            let context = appDelegate.persistentContainer.viewContext
            self.cleanPharmacys(context)
        
            for pharmacy in pharmacys {
                let pharmacyEntity = NSEntityDescription.entity(forEntityName: "Pharmacy", in: context)!
                let newPharmacy = NSManagedObject(entity: pharmacyEntity, insertInto: context)
                newPharmacy.setValue(pharmacy.name, forKey: "name")
                newPharmacy.setValue(pharmacy.isCurrentLocation, forKey: "isCurrentLocation")
                newPharmacy.setValue(pharmacy.phoneNumber, forKey: "phoneNumber")
                newPharmacy.setValue(pharmacy.placemark.countryCode, forKey: "countryCode")
                newPharmacy.setValue(pharmacy.placemark.coordinate.latitude, forKey: "latitude")
                newPharmacy.setValue(pharmacy.placemark.coordinate.longitude, forKey: "longitude")
                newPharmacy.setValue(pharmacy.url!.absoluteURL.absoluteString, forKey: "url")
                newPharmacy.setValue(pharmacy.placemark.locality, forKey: "locality")
                newPharmacy.setValue(pharmacy.placemark.subLocality, forKey: "subLocality")
            }
            
            do {
                try context.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }

        }
        
        func loadData(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pharmacy")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                
                // forcing it to be casted to NSManagedObject
                pharmacys = (result as? [NSManagedObject])!

            } catch {
                print("Failed")
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
    
    /*
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return pharmacys.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellIdentifier = "PharmacyViewCell"
              /*
             guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PharmacyCell else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
             }
             // Fetches the appropriate medication for the data source layout.
            let pharmacy = pharmacys[indexPath.row]
            cell.name.text = pharmacy.value(forKey: "name") as? String

 */
        let cell = UITableViewCell()
        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        let pharmacy = pharmacys[indexPath.row]
        label.text = pharmacy.value(forKey: "name") as? String
        cell.addSubview(label)
        return cell
       }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pharmacys.count
            }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = UITableViewCell()
                let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
              print(pharmacys.count)

                let pharmacy = pharmacys[indexPath.row]
                label.text = pharmacy.value(forKey: "name") as? String
                cell.addSubview(label)
                return cell
            }

    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }


            // UITableViewDelegate Functions

            func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                return 50
            }

}


    extension PharmacyViewController: CLLocationManagerDelegate{
        
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


