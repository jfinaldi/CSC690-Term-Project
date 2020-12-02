//
//  ContactTracingBrain.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/28/20.
//

import UIKit

class ContactTracingBrain {
    
    var username: String = ""
    var isRegistered: Bool = true
    var isLoggedIn: Bool = true
    var isInfected: Bool = false
    var isAtRisk: Bool = false
    var isQuarantined: Bool = false
    var quarantineDaysLeft: Int?
    var qBrain: QuarantineBrain?
    let getTestedLink: String = "https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/testing.html"
    
    init() {
        self.username = ""
        self.isRegistered = true
        self.isLoggedIn = true
        self.isInfected = false //THIS IS ALL HARD CODED DATA FOR TESTING
        self.isAtRisk = false
        self.isQuarantined = false
    }
    
    //function to start a quarantine
    //function to mark infected/recovered
    //function to call 911(?)
    
    //function to pull all the gps coordinates of infected users
    
    //function compare the user's gps coords radii with the coords radii of the infected users
        //return true or false
    
    //function to create the radius of a single gps coordinate
        
    //sends this to the VC to update the map
    
    //function to check if today's day is the same day as our quarantine end
        //Send notifications
    
}

