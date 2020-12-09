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
    @IBOutlet weak var errorMsg: UILabel!
    
    var loginToken: String?
    var userDefaults = UserDefaults.standard
    
    
    @IBAction func submitClicked(_ sender: Any) {
        
        //reset error if there is ne
        if errorMsg.isHidden == true {
            errorMsg.isHidden = false
        }
        
        //output a modal if user leaves a field blank
        guard !(username.text!.isEmpty) && !(password.text!.isEmpty) else {
            let alert = UIAlertController(title: "ಠ_ಠ", message: "Fill out all fields please", preferredStyle: .alert)
            self.present(alert, animated: true)
            let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            alert.addAction(action)
            return
        }
        
        //this is temporary
        guard let name: String = username.text, let pass: String = password.text else {
            errorMsg.isHidden = false
            return
        }
        
        // TODO: verify login information
        DispatchQueue.global().async { [self] in
            DataModelServices().login(username: name, password: pass, device_token: "", callback: {
                loginToken in
                //self.userDefaults.set(loginToken, forKey: "login_token")
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
        } else {
            errorMsg.isHidden = false //output error message for fail to login
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
        
        self.navigationItem.setHidesBackButton(true, animated: false)

        //get user defaults
        userDefaults = UserDefaults.standard
        
        //loginToken = "1607222910103"
        //loginToken = userDefaults.string(forKey: "login_token")
        
        //make error message invisible
        errorMsg.isHidden = true
    }

    

}
