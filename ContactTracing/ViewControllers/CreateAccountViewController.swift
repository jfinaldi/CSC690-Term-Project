//
//  CreateAccountViewController.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var uploadPicButton: UIButton!
    @IBOutlet weak var username: UITextField! = nil
    @IBOutlet weak var password: UITextField! = nil
    
    
    
    @IBAction func submitClicked(_ sender: Any) {
        //make sure we have a username
        guard username.text != "" else {
            print("No username entered")
            return
        }
        //make sure we have a password
        guard password.text != "" else {
            print("No password entered")
            return
        }
        
        //send username and password to database
        DispatchQueue.global().async { [self] in
            //call a function inside DataModelServices to register
        }
        
        //segue back into login
        self.performSegue(withIdentifier: "CreateToLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
