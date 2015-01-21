//
//  LoginViewController.swift
//  Spring
//
//  Created by Joseph Asperger on 12/30/14.
//
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBLoginViewDelegate {
   
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var facebookLoginView: FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageView = UIImageView(image: UIImage(named: "free-wallpaper-19.jpg")!)
        imageView.frame.size = view.frame.size
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        emailField.backgroundColor = UIColor(white: 1, alpha: 0.8)
        passwordField.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        
        errorLabel.text = ""
        emailField.text = "joeyasperger@gmail.com" //just for faster testing
        facebookLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    @IBAction func login(sender: AnyObject) {
        sendLoginRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendLoginRequest() {
        PFUser.logInWithUsernameInBackground(emailField.text, password: passwordField.text) { (user, error) -> Void in
            if ((user) != nil){
                println("success")
                User.loadAllRelations()
                self.performSegueWithIdentifier("LoginSegue", sender: self)
            }
            else{
                if let errorString = error.userInfo?["error"] as? String {
                    self.errorLabel.text = errorString
                }
                NSLog("%@", error)
            }
        }
    }
    
    func transitionAfterLogin() {
        performSegueWithIdentifier("LoginSegue", sender: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == passwordField){
            sendLoginRequest()
        }
        if (textField == emailField){
            passwordField.becomeFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //hide any keyboards if user touches out of text field
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        // TODO
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoginSegue"){
            
        }
    }
    
}
