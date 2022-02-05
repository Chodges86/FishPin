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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.tintColor = .black
        
        // Set navigation bar to clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Setup for camera button
        self.cameraButton.layer.cornerRadius = cameraButton.frame.width/2
        self.cameraButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.cameraButton.layer.shadowRadius = 5
        self.cameraButton.layer.shadowOpacity = 0.3
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
      
        if let type = typeTextField.text,
           let weight = weightTextField.text,
           let length = weightTextField.text,
           let lure = lureTextField.text,
           let dateTime = dateTimeTextField.text,
           let weather = weatherTextField.text,
           let notes = notesTextField.text {
            
            let newEntry = Entry(fishType: type, weight: weight, length: length, lure: lure, dateTime: dateTime, weather: weather, notes: notes)
            print(newEntry)
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


