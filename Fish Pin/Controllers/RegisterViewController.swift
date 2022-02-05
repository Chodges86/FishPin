//
//  RegisterViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 9/29/21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar to clear with white letters
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    //TODO: Show alert with error message
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "RegisterToMap", sender: self)
                }
            }
        }
    } // End registerTapped
}
