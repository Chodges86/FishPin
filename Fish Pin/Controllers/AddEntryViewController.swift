//
//  AddEntryViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/3/22.
//

import UIKit

class AddEntryViewController: UIViewController {
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var lureTextField: UITextField!
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var weatherTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    
    var latitude = Double()
    var longitude = Double()
    
    let dataModel = DataModel()
    var weatherManager = WeatherManager()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Setup the navigationController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // Setup for camera button
        cameraButton.layer.cornerRadius = cameraButton.frame.width/2
        cameraButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        cameraButton.layer.shadowRadius = 5
        cameraButton.layer.shadowOpacity = 0.3
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        weatherManager.getWeather(latitude, longitude)
        dateTimeTextField.text = dataModel.getDateTime()
    }
    
    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
      
        if let type = typeTextField.text,
           let weight = weightTextField.text,
           let length = weightTextField.text,
           let lure = lureTextField.text,
           let dateTime = dateTimeTextField.text,
           let weather = weatherTextField.text,
           let notes = notesTextField.text {
            
            let newEntry = Record(context: dataModel.context)
            newEntry.type = type
            newEntry.weight = weight
            newEntry.length = length
            newEntry.lure = lure
            newEntry.dateTime = dateTime
            newEntry.weather = weather
            newEntry.notes = notes
            newEntry.latitude = latitude
            newEntry.longitude = longitude
            
            dataModel.saveRecord()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func takePicturePressed(_ sender: UIButton) {
        
        UIView.transition(with: sender, duration: 0.2, options: .curveLinear) {
            self.cameraButton.imageView?.tintColor = .white
        } completion: { _ in
            self.cameraButton.imageView?.tintColor = .black
        }
    }
}
// MARK: - Text Field Delegate Methods

extension AddEntryViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      
        switch textField.tag {
        case 1: // Automatically inlude the unit of measurement
            textField.text = "\(textField.text ?? "") lbs"
        case 2: // Automatically inlude the unit of measurement
            textField.text = "\(textField.text ?? "") inches"
        case 5:
            if textField.text == "" {
               //TODO: Replace the deleted text with weather data again if user deleted text and wants it back
            }
        default:
            break
        }
        
    }    
}

// MARK: - WeatherDelegate Methods

extension AddEntryViewController: WeatherDelegate {
    func didRecieveWeather(_ weather: WeatherData) {
        
        DispatchQueue.main.async {
            let temp = String(weather.main.temp)
            let description = weather.weather[0].description
            self.weatherTextField.text = "\(description)  \(temp)°F"
        }
        
        print(weather.main.temp)
        print(weather.weather.description)
    }
    
    func didRecieveError(_ error: Error?) {
        print(error!)
    }
    
    
}
