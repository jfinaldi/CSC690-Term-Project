//
//  ContactTracingBrain.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/28/20.
//

import UIKit

class ContactTracingBrain {
    
    var username: String
    var isRegistered: Bool
    var isInfected: Bool
    var isQuarantined: Bool
    var quarantineDaysLeft: Int?
    var qBrain: QuarantineBrain?
    let getTestedLink: String = "https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/testing.html"
    
    init() {
        self.username = ""
        self.isRegistered = false
        self.isInfected = false
        self.isQuarantined = false
    }
    
    //function to start a quarantine
    //function to mark infected/recovered
    //function to call 911
    
    
}

class QuarantineBrain {
    
    static let qCounterUpdated = Notification.Name("QuarantineBrain.qCounterUpdated")
    static let qCounterFinished = Notification.Name("QuarantineBrain.qCounterFinished")
    
    let seconds: TimeInterval = 1209600
    let secondsPerDay: Double = 86400
    
    var daysLeft: Int?
    var secondsLeft: TimeInterval?
    var timer: Timer?
    
    func startCountdown() {
            
        
        //countdown the specific number
        //notify that the counter has decremented
        //notify that days have changed
        //notify that hours have changed
        //notify that minutes have changed
        //notify that seconds have changed
        //if everything goes to 0, notify that the counter has finished
            //invalidate the timer
        
        secondsLeft = self.seconds
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) -> Void in
            guard let secondsLeft = self.secondsLeft else {
                return
            }
            let newSeconds = secondsLeft - 1
            
            if newSeconds >= 0 {
                self.secondsLeft = newSeconds
                let dL: Double = newSeconds / self.secondsPerDay //derive the days in doubles
                self.daysLeft = Int(dL) //truncate and save as integer
                //Notify that seconds have changed
                NotificationCenter.default.post(name: QuarantineBrain.qCounterUpdated, object: nil)
            }
            if newSeconds == 0 {
                print("Done!")
                NotificationCenter.default.post(name: QuarantineBrain.qCounterFinished, object: nil)
                timer.invalidate()
            }
        })
    }
}
