//
//  ViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 9/29/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set navigation bar to clear
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.view.backgroundColor = .clear
        navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func registerSegueTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterToLogin", sender: self)
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    //TODO: Handle sign in error
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "LoginToMap", sender: self)                }
            }
        }
    }
}

