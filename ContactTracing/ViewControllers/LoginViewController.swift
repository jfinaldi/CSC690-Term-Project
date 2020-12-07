//
//  LoginViewController.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField! = nil
    @IBOutlet weak var password: UITextField! = nil
    
    var loginToken: String?
    
    @IBAction func submitClicked(_ sender: Any) {
        
        //this is temporary
        guard let name: String = username.text else {
            return
        }
        guard let pass: String = password.text else {
            return
        }
        
        // TODO: verify login information
        print(name)
        print(pass)
        
        //Go to Home screen if user data is valid
        self.performSegue(withIdentifier: "LoginToHome", sender: self)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccountViewController", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get user defaults
        loginToken = "1607222910103"
        
        //if there is a token then segue into home VC
        //if loginToken != nil {
            self.performSegue(withIdentifier: "LoginToHome", sender: self) //This doesn't work!
        //}
        
        
        //if there is not a token then stay here
    }

    

}
