//
//  RegisterViewController.swift
//  StasChat
//
//  Created by Stanislav Cherkasov on 14.07.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      registerButton.layer.cornerRadius = 15
      registerButton.clipsToBounds = true
      
    }
    
    @IBAction func registerPressedButton(_ sender: Any) {
        // Set up a new user to Firebase Database
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error.debugDescription)
            }
            else {
                print("Succesfull")
                self.performSegue(withIdentifier: "goToTheChat", sender: self)
            }
        }
    }
}
