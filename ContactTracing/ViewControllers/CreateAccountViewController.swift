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
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    @IBAction func submitClicked(_ sender: Any) {
        //make sure we have a username
        //make sure we have a password
        //photo not mandatory
        //send username and password to database
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
