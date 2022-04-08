//
//  AddEntryViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/3/22.
//

import UIKit

class EntryViewController: UIViewController {
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var lureTextField: UITextField!
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var weatherTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var textFieldStack: UIStackView!
    @IBOutlet weak var textStackBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var dimmerView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var latitude = Double()
    var longitude = Double()
    
    let dataModel = DataModel()
    var weatherManager = WeatherManager()
    
    var currentTextField: UITextField?
    var currentWeather = ""
    
    var recordToEdit: Record?
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        deleteButton.isHidden = true
        
        // Setup the navigationController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Setup for camera button
        cameraButton.layer.cornerRadius = cameraButton.frame.width/2
        cameraButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        cameraButton.layer.shadowRadius = 5
        cameraButton.layer.shadowOpacity = 0.3
        
        // Setup view when editing an existing record
        
        if recordToEdit != nil {
            latitude = recordToEdit!.latitude
            longitude = recordToEdit!.longitude
            deleteButton.isHidden = false
            deleteButton.layer.cornerRadius = deleteButton.frame.width/25
            deleteButton.layer.shadowOffset = CGSize(width: 10, height: 10)
            deleteButton.layer.shadowRadius = 5
            deleteButton.layer.shadowOpacity = 0.3
            navigationItem.rightBarButtonItem?.title = "Save"
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        weatherManager.getWeather(latitude, longitude)
        dateTimeTextField.text = dataModel.getDateTime()
        
        // Notify keyboard has appeared
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
        // Insert data from record into the textfields and imageview
        if recordToEdit != nil {
            
            //Image
            if let image = UIImage(data: (recordToEdit?.image)!) {
                picView.image = image
            } else {
                picView.image = UIImage(named: "FishPinLogo")
            }
            //TextFields
            typeTextField.text = recordToEdit?.type
            weightTextField.text = recordToEdit?.weight
            lengthTextField.text = recordToEdit?.length
            lureTextField.text = recordToEdit?.lure
            dateTimeTextField.text = recordToEdit?.dateTime
            weatherTextField.text = recordToEdit?.weather
            notesTextField.text = recordToEdit?.notes
            
        }
    }
    
    @objc func keyboardWillDisappear() {
        dimmerView.alpha = 0
    }
    
    // Handle the movement of the text fields to be visible above keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            dimmerView.backgroundColor = .black
            dimmerView.alpha = 0.4
            
            if let textField = currentTextField {
                
                // Move currentTextField to just above top of keyboard if it's the last textField
                if textField.tag != 6 {
                    let keyboardY = view.frame.size.height - keyboardHeight
                    let textFieldBottomYTarget = textFieldStack.frame.origin.y + textField.frame.origin.y + (textField.frame.size.height*2) + 5
                    let difference = keyboardY - textFieldBottomYTarget
                    
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                        self.textStackBottonConstraint.constant -= difference
                        self.view.layoutIfNeeded()
                    }
                    
               // Move currentTextField to above the keyboard plus the height of another textField so that it is able to be selected
                } else {
                    let keyboardY = view.frame.size.height - keyboardHeight
                    let textFieldBottomYTarget = textFieldStack.frame.origin.y + textField.frame.origin.y + (textField.frame.size.height) + 5
                    let difference = keyboardY - textFieldBottomYTarget
                    
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                        self.textStackBottonConstraint.constant -= difference
                        self.view.layoutIfNeeded()
                    }
                }
            }
         }
    }
    
    // Handle done button tapped on keyboard
    @objc func doneTapped() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.dimmerView.alpha = 0
            self.textStackBottonConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - IB Action Functions
    
    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
        
        // Delete the old record if user is editing a previously recorded record
        if recordToEdit != nil {
            dataModel.context.delete(recordToEdit!)

        }
        
        // Create properties holding values that user has entered for record
        if let type = typeTextField.text,
           let weight = weightTextField.text,
           let length = weightTextField.text,
           let lure = lureTextField.text,
           let dateTime = dateTimeTextField.text,
           let weather = weatherTextField.text,
           let notes = notesTextField.text {
            
            // Create a record entry
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
            newEntry.image = picView.image?.pngData()
            
            // Save record to CoreData File and return to mapView
            dataModel.saveRecord()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func takePicturePressed(_ sender: UIButton) {
        
        // Animate the button pressed because with system image the button doesn't animate on it's own
        UIView.transition(with: sender, duration: 0.2, options: .curveLinear) {
            self.cameraButton.imageView?.tintColor = .white
        } completion: { _ in
            self.cameraButton.imageView?.tintColor = .black
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        //TODO: Add alert to confirm delete record

        if recordToEdit != nil {
            dataModel.context.delete(recordToEdit!)
        }
        navigationController?.popViewController(animated: true)
        dataModel.saveRecord()
    }
    
    
}
// MARK: - Text Field Delegate Methods

extension EntryViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        deleteButton.isHidden = false
        
        switch textField.tag {
        case 1: // Automatically inlude the unit of measurement
            if !textField.text!.contains("lbs"){
                textField.text = "\(textField.text ?? "lbs") lbs"
            }
        case 2: // Automatically inlude the unit of measurement
            if !textField.text!.contains("inches") {
                textField.text = "\(textField.text ?? "inches") inches"
            }
        case 4: // Reenter time/date if user leaves textField blank
            if textField.text!.isEmpty {
                dateTimeTextField.text = dataModel.getDateTime()
            }
        case 5:
            if textField.text!.isEmpty {
                textField.text = currentWeather
            }
        default:
            break
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        deleteButton.isHidden = true
        
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: false)
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        
        currentTextField = textField
        
    }
}


// MARK: - WeatherDelegate Methods

extension EntryViewController: WeatherDelegate {
    func didRecieveWeather(_ weather: WeatherData) {
        
        DispatchQueue.main.async {
            let temp = String(weather.main.temp)
            let description = weather.weather[0].description
            self.currentWeather = "\(description)  \(temp)°F"
            self.weatherTextField.text = self.currentWeather
        }
    }
    
    func didRecieveError(_ error: Error?) {
        print(error!)
    }
}

extension EntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        picView.image = image
    }
    
}
