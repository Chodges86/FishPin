//
//  MapViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 9/29/21.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var recordButtonView: UIView!
    @IBOutlet weak var settingsButtonView: UIView!
    @IBOutlet weak var locationMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let dataModel = DataModel()
    

 
    
// MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Unhide Nav bar
        navigationController?.isNavigationBarHidden = false
        
        // Setup the navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let logo = UIImage(named: "FishPinLogo.png")
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
        navigationItem.titleView?.contentMode = .scaleAspectFit
        
        // Set up the buttons appearance
        recordButtonView.layer.cornerRadius = recordButtonView.frame.width/2
        settingsButtonView.layer.cornerRadius = settingsButtonView.frame.width/2

        recordButtonView.layer.shadowOffset = CGSize(width: 10, height: 10)
        recordButtonView.layer.shadowRadius = 5
        recordButtonView.layer.shadowOpacity = 0.3

        settingsButtonView.layer.shadowOffset = CGSize(width: 10, height: 10)
        settingsButtonView.layer.shadowRadius = 5
        settingsButtonView.layer.shadowOpacity = 0.3
        
        // Get data and layout pins from all recorded catches
        dataModel.loadRecord()
        placePins()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationMapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled(){

            // Get the user's current location
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        } else {
            // Location services disabled
            // TODO: Show alert stating to turn on location services in settings
            print("Location Off")
        }
        
        // If location privacy settings are not determined, ask the user to allow location services
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
        
    }
 
// MARK: - IBAction functions
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
    }
    
    @IBAction func addEntryPressed(_ sender: UIBarButtonItem) {
        
        let newEntry = MyAnnotation()
        newEntry.identifier = "FishLocation"
        
        
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            
            newEntry.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
            locationMapView.addAnnotation(newEntry)
        } else {
            //TODO: Determine best way to deal with a pin not being able to be dropped
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.performSegue(withIdentifier: "AddEntrySegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddEntrySegue" {
            let destVC = segue.destination as! EntryViewController
            if let latitude = locationManager.location?.coordinate.latitude,
               let longitude = locationManager.location?.coordinate.longitude {
                destVC.latitude = latitude
                destVC.longitude = longitude
            }
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "RecordSegue", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "SettingSegue", sender: self)
    }
    
// MARK: - Place Pins function
    
    func placePins() {
        var pinsArray = [MKPointAnnotation]()
        // Remove annotations so that old pins that do not exist anymore are removed from view before placing current array of pins into the view
        locationMapView.removeAnnotations(locationMapView.annotations)
        
        // Loop through the records, create an annotation from lat and lon and add it the mapview
        for record in dataModel.records {
            
            let entry = MyAnnotation()
            entry.identifier = "FishLocation"
            entry.coordinate = CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude)
            pinsArray.append(entry)
            
        }
        locationMapView.addAnnotations(pinsArray)
    }
    
}

// MARK: - CLLocationManager and MapView Delegate Methods

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil{
            
            manager.stopUpdatingLocation()
            
            let coordinates = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinates, span: span)
            
            locationMapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            // TODO: Show alert with instructions to turn location services on
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Show alert with error
        print("locationManager failed with error: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MyAnnotation else {return nil}
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "FishMarker")
        annotationView.displayPriority = .required
        
        if annotation.identifier == "FishLocation" {
            annotationView.glyphImage = UIImage(named: "FishIcon")
            annotationView.glyphTintColor = .black
            annotationView.markerTintColor = .white
            annotationView.animatesWhenAdded = true
            return annotationView
        }
       return annotationView
    }
}

// MARK: - MyAnnotation Class

// For adding a way to identify types of pins as "FishLocation"
class MyAnnotation: MKPointAnnotation {
    var identifier: String?
}
