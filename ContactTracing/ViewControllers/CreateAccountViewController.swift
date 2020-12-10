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
            return
        }
        
        // TODO: verify login information
        DispatchQueue.global().async { [self] in
            DataModelServices().signup(username: name, password: pass, callback: { () in
                
                //do important stuff in the main thread
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "CreateToLogin", sender: self)
                }
            })
        }
        print(name)
        print(pass)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Do any additional setup after loading the view.
    }
    
}
