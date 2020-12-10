//
//  ViewController.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//  This VC deals with the very entry of the program,
//  deciding exactly which view to present to the
//  user upon launch of the app.

import UIKit

class ContactTracingViewController: UIViewController {
    
    let mainBrain = ContactTracingBrain()
    var userDefaults = UserDefaults.standard
    var isReg: Bool = false
    var isLogged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
		overrideUserInterfaceStyle = .light
        
        //load user defaults information
        //mainBrain.isLoggedIn = userDefaults.object(forKey: "")
        
        //assign mainBrain
        //call functions to determine their registration status
        setIsReg();
        setIsLogged();
    }
    
    func setIsReg() {
        self.isReg = mainBrain.isRegistered
    }
    
    func setIsLogged() {
        self.isLogged = mainBrain.isLoggedIn
    }
    
    
    func goto() {
        //if user is logged in go to home view controller
        if isLogged {
            print("User is logged in")
        }
    
        //if user is not logged in
        else {
            print("User is not logged in")
            //if user is registered, go to login screen
            if isReg {
                print("I'm going to the login screen")
            } else {
                print("I'm going to the registration screen")
                //if user is not registered, go to create account screen
            }
        }
    }


}

