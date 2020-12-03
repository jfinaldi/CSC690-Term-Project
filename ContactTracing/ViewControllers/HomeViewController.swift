//
//  HomeViewController.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//
import MapKit
import UIKit

//STRUCT FOR VIEW COMPONENTS
//View1: Hold variables for not infected or quarantine
//View2: Hold variables for infected
//View3: Hold variables for not infected but quarantined
//Every time a user clicks a button that induces a
//status change, the view switches to that configuration
//simply by changing the buttons or everything below the map

enum greenButtons: String, CaseIterable, CustomStringConvertible {
    case tested = "Get Tested"
    case recovery = "Report Recovery"
    
    var description: String {
        return self.rawValue
    }
}

enum redButtons: String, CaseIterable, CustomStringConvertible {
    case infected = "Report Infected"
    case emergency = "Call 911"
    
    var description: String {
        return self.rawValue
    }
}

enum statusLabels: String, CaseIterable, CustomStringConvertible {
    case infected = "Sick: Quarantined"
    case quarantined = "Quarantined"
    case healthy = "Covid Tracker"
    
    var description: String {
        return self.rawValue
    }
}
    
struct ViewComponents {
    let redButton: redButtons
    let greenButton: greenButtons
    let status: statusLabels
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var home1Label: UILabel!
    @IBOutlet weak var qLabel1: UILabel!
    @IBOutlet weak var qLabel2: UILabel!
    
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    var userPhase = 1 //1 for healthy, 2 for at risk, 3 for infected
    var vComp = ViewComponents(redButton: redButtons.infected, greenButton: greenButtons.tested, status: statusLabels.healthy)
    
    let cBrain = ContactTracingBrain()
    let qBrain = QuarantineBrain()
    
    @IBOutlet weak var map1: MKMapView!
    
 
    @IBAction func redButtonClicked(_ sender: Any) {
        switch userPhase {
        case 1: //start infection
            beginInfection()
            userPhase = 3
        case 2: //start infection
            beginInfection()
            userPhase = 3
        case 3: //call 911
            call911()
        default: print("Eat dirt")
                
        }
    }
    
    
    func beginInfection() {
        cBrain.isInfected = true //mark user infected
        //send data to the server to notify other users
        //start a quarantine
        blueButton.isHidden = true //hide the blue button
        //show the quarantine countdown info
        flipQLabels()
    }
    
    func call911() {
        //we won't actually have their phone call 911
        //perhaps we'll do a modal that asks the user if they are sure
        //create modal
        //create yes button
        //create no button
        //display button
        //            //if no, do nothing
        //            //if yes, output modal that says help on the way
        //                //create modal
        //                //create dismiss button for modal
    }
    
    func flipQLabels() {
        qLabel1.isHidden = !qLabel1.isHidden
        qLabel2.isHidden = !qLabel2.isHidden
    }
    
    @IBAction func greenButtonClicked(_ sender: Any) {
        switch userPhase {
        case 1: //start infection
            goGetTested()
        case 2: //start infection
            beginInfection()
            userPhase = 3
        case 3: //call 911
            call911()
        default: print("Eat dirt")
                
        }
    }
    
    func goGetTested() {
        
    }
    
    @IBAction func beginQuarantineClicked(_ sender: Any) {
        //qBrain.startCountdown()
        cBrain.isQuarantined = true
        blueButton.isHidden = true //hide the blue button
        flipQLabels()
        //change view buttons
    }
    
    
//    @IBAction func recoveryClicked(_ sender: Any) {
//        //unmark user infected
//        //update database
//        //stop quarantine(?)
//        //change the view buttons
//        //blueButton.isHidden = false
//        //
//    }
    
    @objc func updateCounter() {
        
    }
    
    @objc func countdownCompleted() {
        
    }
    
    func changeButtonText(from: String, to: String) {
        //determine which button to change
        //if redButton
        //button.setTitle("my text here", for: .normal)
        //if greenButton
        //button.setTitle("my text here", for: .normal)
        //if blueButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueButton.setTitle( "Begin Quarantine" , for: .normal )
        blueButton.isHidden = false
        home1Label.text = vComp.status.rawValue
        qLabel1.isHidden = true
        qLabel2.isHidden = true
        

        //add our notifications
//        NotificationCenter.default.addObserver(self, selector: #selector(updateCounter),
//                                               name: QuarantineBrain.qCounterUpdated,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(countdownCompleted),
//                                               name: QuarantineBrain.qCounterFinished,
//                                               object: nil)
    }
    
}
