//
//  ForgotPasswordViewController.swift
//  FitSync
//
//  Created by Viraj Barvalia on 3/19/25.
//

/*
 This ForgotPasswordViewController handles the password reset functionality using Firebase Authentication.

1. The user inputs their registered email address.
2. On clicking the "Send Verification" button, the app validates the input.
3. If valid, it sends a password reset email to the provided address using Firebase.
4. If successful, it shows a confirmation alert and redirects the user to the login screen.
5. If it fails, an error alert is shown with the relevant message.
*/


import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    //Outlet for email input field
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Action for "Send Verification Email" button
    @IBAction func sendVerificationClicked(_ sender: UIButton) {
        //Validate email input
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Alert", message: "Please enter your email")
            return
        }
        
        //Firebase function to send password reset email
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                //If there's an error, show error alert with Firebase error message
                print("error")
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            } else {
                //If successful, show confirmation and go back to login screen
                let alertController = UIAlertController(title: "Success", message: "Password reset email sent. Check your inbox.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.performSegue(withIdentifier: "goToLoginAgain", sender: self)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }

    //Show alert function
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

