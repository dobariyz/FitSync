//
//  LoginViewController.swift
//  FitSync
//
//  Created by Viraj Barvalia on 3/17/25.
//

/*
 This LoginViewController manages user login functionality for the FitSync app using Firebase Authentication.

1. It provides two text fields for users to enter their email and password.
2. When the "Login" button is clicked, it validates the input fields.
3. If input is valid, it attempts to authenticate the user using Firebase's "signIn" method.
4. On success, the user is navigated to the next screen (via segue "goToSuccess").
5. If login fails, an alert is shown with an error message.
6. Also includes a helper function to standardize alert presentation.
*/


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    //Outlets for user input
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Login Button Action
    @IBAction func loginClicked(_ sender: UIButton) {
            //Validate email field
            guard let email = emailTextField.text, !email.isEmpty else {
                showAlert(title: "Alert", message: "Please enter your email")
                return
            }
            //Validate password field
            guard let password = passwordTextField.text, !password.isEmpty else {
                showAlert(title: "Alert", message: "Please enter your password")
                return
            }

        // Firebase Authentication - Attempt login
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
               if let error = error as NSError? {
                        //Show alert on login failure
                       self.showAlert(title: "Alert", message: "Something Went Wrong! Try Again.")
               } else {
                   //On successful login, perform segue to next screen
                   self.performSegue(withIdentifier: "goToSuccess", sender: self)
               }
           }
        }

        //Function to show alerts
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }

}
