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
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Setup the navigationController
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        let logo = UIImage(named: "FishPinLogo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        
        self.tabBarController?.tabBar.isHidden = false
        
        recordButtonView.layer.cornerRadius = recordButtonView.frame.width/2
        settingsButtonView.layer.cornerRadius = settingsButtonView.frame.width/2
        
        recordButtonView.layer.shadowOffset = CGSize(width: 10, height: 10)
        recordButtonView.layer.shadowRadius = 5
        recordButtonView.layer.shadowOpacity = 0.3
        
        settingsButtonView.layer.shadowOffset = CGSize(width: 10, height: 10)
        settingsButtonView.layer.shadowRadius = 5
        settingsButtonView.layer.shadowOpacity = 0.3
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        } else {
            
            // TODO: Show alert stating to turn on location services in settings
        }
    }
    
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
        performSegue(withIdentifier: "AddEntrySegue", sender: self)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "RecordSegue", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "SettingSegue", sender: self)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
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
        print("locationManager failed with error")
    }
}

