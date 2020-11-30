//
//  HomeViewController.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//
import MapKit
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var home1Label: UILabel!
    @IBOutlet weak var home2Label: UILabel!
    @IBOutlet weak var home3Label: UILabel!
    
    let cBrain = ContactTracingBrain()
    let qBrain = QuarantineBrain()
    
    @IBOutlet weak var map1: MKMapView!
    @IBOutlet weak var map2: MKMapView!
    @IBOutlet weak var map3: MKMapView!
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    @IBAction func infectedButtonClicked(_ sender: Any) {
        //mark user infected
        //send data to the server to notify other users
        //start a quarantine
    }
    
    @IBAction func getTestedClicked(_ sender: Any) {
        //take user to the link inside cBrain
    }
    
    @IBAction func beginQuarantineClicked(_ sender: Any) {
        //qBrain.startCountdown()
        cBrain.isQuarantined = true
    }
    
    @IBAction func call911Clicked(_ sender: Any) {
        //we won't actually have their phone call 911
        //perhaps we'll do a modal that asks the user if they are sure
            //create modal
            //create yes button
            //create no button
            //display button
            //if no, do nothing
            //if yes, output modal that says help on the way
                //create modal
                //create dismiss button for modal
    }
    
    @IBAction func recoveryClicked(_ sender: Any) {
        //unmark user infected
        //update database
        //stop quarantine(?)
    }
    
    @objc func updateCounter() {
        
    }
    
    @objc func countdownCompleted() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //add our notifications
//        NotificationCenter.default.addObserver(self, selector: #selector(updateCounter),
//                                               name: QuarantineBrain.qCounterUpdated,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(countdownCompleted),
//                                               name: QuarantineBrain.qCounterFinished,
//                                               object: nil)
    }
    
}
