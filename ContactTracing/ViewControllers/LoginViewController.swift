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
    var userDefaults = UserDefaults.standard
    
    
    @IBAction func submitClicked(_ sender: Any) {
        
        //this is temporary
        guard let name: String = username.text else {
            return
        }
        guard let pass: String = password.text else {
            return
        }
        
        // TODO: verify login information
        DispatchQueue.global().async { [self] in
            DataModelServices().login(username: name, password: pass, device_token: "", callback: {
                loginToken in
                self.userDefaults.set(loginToken, forKey: "login_token")
//                DataModelServices().getLocation(username: name, login_token: loginToken, callback: { (locations) in
//                    print(locations)
//                })
            })
        }
        print(name)
        print(pass)
        
        
        
        //Go to Home screen if user data is valid
        if loginToken != nil {
            print("\n\n\nWE HAVE A LOGIN TOKEN\n\n\n")
            self.performSegue(withIdentifier: "LoginToHome", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if loginToken != nil {
            self.performSegue(withIdentifier: "LoginToHome", sender: self) //This doesn't work!
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccountViewController", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get user defaults
        userDefaults = UserDefaults.standard
        
        loginToken = "1607222910103"
        //loginToken = userDefaults.string(forKey: "login_token")
        
        //if there is a token then segue into home VC
        //if loginToken != nil {
            self.performSegue(withIdentifier: "LoginToHome", sender: self) //This doesn't work!
        //}
        
        
        
        //if there is not a token then stay here
    }

    

}
