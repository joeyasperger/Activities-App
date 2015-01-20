//
//  SignUpViewController.swift
//  Spring
//
//  Created by Joseph Asperger on 1/5/15.
//
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabel.text = ""
    }
    
    @IBAction func signup(sender: AnyObject) {
        signupUser()
    }

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signupUser() {
        if (fieldsValid()){
            var user = PFUser()
            user.username = emailField.text
            user.password = passwordField.text
            user["displayName"] = usernameField.text
            user.signUpInBackgroundWithBlock({ (succeeded, error) -> Void in
                if (succeeded) {
                    CurrentUserRelations.downloadRelations()
                    User.loadEvents()
                self.performSegueWithIdentifier("SignupSegue", sender: self)
                }
            })
        }
    }
    
    func fieldsValid() -> Bool {
        if (countElements(emailField.text) == 0){
            errorLabel.text = "Email address missing"
            return false
        }
        if (countElements(usernameField.text) < 4 || countElements(usernameField.text) > 20){
            errorLabel.text = "Username must be 4 to 20 characters"
            return false
        }
        if (countElements(passwordField.text) < 8 || countElements(passwordField.text) > 20){
            errorLabel.text = "Password must be 8 to 20 characters"
            return false
        }
        if (passwordField.text != confirmPasswordField.text){
            errorLabel.text = "Passwords do not match"
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //move to next text field when user taps next
        if (textField == emailField){
            usernameField.becomeFirstResponder()
        }
        if (textField == usernameField){
            passwordField.becomeFirstResponder()
        }
        if (textField == passwordField){
            confirmPasswordField.becomeFirstResponder()
        }
        if (textField == confirmPasswordField){
            confirmPasswordField.resignFirstResponder()
            signupUser()
        }
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // hide keyboard if user taps outside of text fields
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
    }
}
