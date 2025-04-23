//
//  ViewController.swift
//  FitSync
//
//  Created by Viraj Barvalia on 3/16/25.
//

/*
 This ViewController handles user registration (sign-up) for the FitSync app using Firebase Authentication.
1. It contains two input fields: one for the user's email and one for the password.
2. When the "Sign Up" button is clicked, it reads the input values and attempts to create a new user account using Firebase.
3. If the registration is successful, a success alert is shown and the user is redirected to the login screen via a segue.
3. If there's an error (such as an invalid email or weak password), an error alert is displayed instead.
*/


import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    //Outlets for email and password input fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Sign-Up Button Action
    @IBAction func signupClicked(_ sender: UIButton) {
        //Get email and password input from user
        guard let email = emailTextField.text else{
            return
        }
        guard let password = passwordTextField.text else{
            return
        }
        
        //Use Firebase Authentication to create a new user
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            // If there's an error (e.g., email already used, weak password), show alert
            if let e = error{
                let alert = UIAlertController(title: "Alert", message: "Something Went Wrong! Try Again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else { // If sign-up is successful, show success alert and navigate to Login screen
                let alertController = UIAlertController(title: "Success", message: "Sign-up Successful.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.performSegue(withIdentifier: "goToLogin", sender: self)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }
}

