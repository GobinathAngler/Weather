//
//  ViewController.swift
//  weatherTasks
//
//  Created by Premkumar Arul on 15/10/22.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationSelected = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Home"
        
        let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest

            // Check for Location Services
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
        
           DispatchQueue.main.async {
               locationManager.startUpdatingLocation()
           }
        
        //Just to Add Marker at some Location
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 11.0168, longitude: 76.9558)
        annotation.title = "Im Here"
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
          self.mapView.addAnnotation(pinAnnotationView.annotation!)

    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
           let location = locations.last as! CLLocation
           let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
           var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
           region.center = mapView.userLocation.coordinate
           mapView.setRegion(region, animated: true)
       }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var pav: MKPinAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: String(annotation.hash)) as? MKPinAnnotationView
        if pav == nil {
            pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            pav?.isDraggable = true
            pav?.canShowCallout = true
            let rightButton = UIButton(type: .contactAdd)
            rightButton.addTarget(self, action: #selector(addToBookMarks), for: .touchUpInside)
            rightButton.tag = annotation.hash
            locationSelected = annotation.coordinate
            pav?.rightCalloutAccessoryView = rightButton
        } else {
            pav?.annotation = annotation
        }
        
        return pav
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .starting:
            print("Start")
        case .ending, .canceling:
            print("end")
            locationSelected = view.annotation?.coordinate ?? CLLocationCoordinate2D()
        default: break
        }
    }
    
    @objc func addToBookMarks() {
        
        saveLocationToCoreData(pdblLatLong: locationSelected)
        self.view.makeToast("Successfully Added to BookMarks!!!", duration: 3.0, position: .top)
        
    
    }
    
    func saveLocationToCoreData(pdblLatLong: CLLocationCoordinate2D) {
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:pdblLatLong.latitude, longitude: pdblLatLong.longitude)
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let ourContext = appDelegate.persistentContainer.viewContext
            let addressContext = NewBookMarks(context: ourContext)
            addressContext.cityAddress = addressString
            print(addressString)
            do {
            try ourContext.save()
            }catch {
                
            }
        })
     
        
        
    }
}

