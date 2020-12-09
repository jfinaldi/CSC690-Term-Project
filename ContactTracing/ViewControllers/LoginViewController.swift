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
        
        //reset error if there is one
        if errorMsg.isHidden == false {
            errorMsg.isHidden = true
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
                print("loginToken: \(loginToken)")
                
                //do important stuff in the main thread
                DispatchQueue.main.async {
                    self.userDefaults.set(loginToken, forKey: "login_token")
                    errorMsg.isHidden = true
                    self.performSegue(withIdentifier: "LoginToHome", sender: self)
                }
            })
        }
        print(name)
        print(pass)
        
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
