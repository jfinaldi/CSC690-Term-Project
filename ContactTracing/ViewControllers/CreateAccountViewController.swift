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
    @IBOutlet weak var nameTaken: UILabel!
    
    
    
    @IBAction func submitClicked(_ sender: Any) {
        nameTaken.isHidden = true
        
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
            DataModelServices().signup(username: name, password: pass, callback: { (success) in
                
                //do important stuff in the main thread
				if success {
					DispatchQueue.main.async {
						self.performSegue(withIdentifier: "CreateToLogin", sender: self)
					}
				} else {
                    DispatchQueue.main.async {
                        self.nameTaken.isHidden = false
                    }
				}
            })
        }
        print(name)
        print(pass)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		overrideUserInterfaceStyle = .light
        
        self.navigationItem.setHidesBackButton(true, animated: false)

        nameTaken.isHidden = true
    }
    
}
