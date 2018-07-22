//
//  LoginViewController.swift
//  StasChat
//
//  Created by Stanislav Cherkasov on 14.07.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var signInButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    signInButton.layer.cornerRadius = 15
    signInButton.clipsToBounds = true
  }
  
  @IBAction func logInPressed(_ sender: Any) {
    Auth.auth().signIn(withEmail: emailTextField.text!,
                       password: passwordTextField.text!) { (user, error) in
                        
                        if error != nil {
                          print(error.debugDescription)
                        } else {
                          print("Succesfull log in)")
                          self.performSegue(withIdentifier: "goToChat",
                                            sender: self)
                        }
    }
  }
}
