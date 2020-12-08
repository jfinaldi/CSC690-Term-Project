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
    
//struct ViewComponents {
//    let redButton: redButtons
//    let greenButton: greenButtons
//    let status: statusLabels
//}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var home1Label: UILabel!
    @IBOutlet weak var qLabel1: UILabel!
    @IBOutlet weak var qLabel2: UILabel!
    
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    var userPhase = 1 //1 for healthy, 2 for at risk, 3 for infected
    //var vComp = ViewComponents(redButton: redButtons.infected, greenButton: greenButtons.tested, status: statusLabels.healthy)
    
    let cBrain = ContactTracingBrain()
    let qBrain = QuarantineBrain()
    var userDefaults = UserDefaults.standard
    
    @IBOutlet weak var map1: MKMapView!
    
 
    @IBAction func redButtonClicked(_ sender: Any) {
        switch userPhase {
        case 1: //start infection
            beginInfection()
            changeUserPhase(to: 3)
        case 2: //start infection
            beginInfection()
            changeUserPhase(to: 3)
        case 3: //call 911
            call911()
        default: print("Eat dirt")
                
        }
    }

    @IBAction func greenButtonClicked(_ sender: Any) {
        print("\nThe user phase is: \(userPhase)")
        
        switch userPhase {
            case 1: //start infection
                goGetTested()
            case 2: //start infection
                goGetTested()
            case 3: //report recovery
                userRecovered()
                changeUserPhase(to: 1)
            default: print("Eat dirt")
        
        }
          
    }
    
    @IBAction func blueButtonClicked(_ sender: Any) {
        beginQuarantine()
    }
    
    func changeUserPhase(to: Int) {
        print("changeUserPhase to \(to)")
        
        userPhase = to
        
        print("userPhase is now \(userPhase)")
        updateButtons()
    }
    
    func updateButtons() {
        switch userPhase {
            case 1:
                redButton.setTitle( redButtons.infected.rawValue , for: .normal )
                greenButton.setTitle(greenButtons.tested.rawValue , for: .normal)
                blueButton.isHidden = false
                qLabel1.isHidden = true
                qLabel2.isHidden = true
                home1Label.text = statusLabels.healthy.rawValue
            case 2:
                redButton.setTitle( redButtons.infected.rawValue , for: .normal )
                greenButton.setTitle(greenButtons.tested.rawValue , for: .normal)
                blueButton.isHidden = true
                qLabel1.isHidden = false
                qLabel2.isHidden = false
                home1Label.text = statusLabels.quarantined.rawValue
            case 3:
                redButton.setTitle( redButtons.emergency.rawValue , for: .normal )
                greenButton.setTitle(greenButtons.recovery.rawValue , for: .normal)
                blueButton.isHidden = true
                qLabel1.isHidden = false
                qLabel2.isHidden = false
                home1Label.text = statusLabels.infected.rawValue
            default:
                print("something went wrong in switch updateButtons")
                print("userPhase: \(userPhase)")
        }
    }
    
    //LESLIE TODO
    func goGetTested() {
        print("go get tested!")
    }
    
    @objc func updateQuarantineDays() {
        guard let days = cBrain.quarantineDaysLeft else {
            print("We don't have any quarantine days left")
            return
        }
        qLabel2.text = "Days Left: \(days)"
    }
    
    func beginQuarantine() {
        //qBrain.startCountdown()
        changeUserPhase(to: 2)
        
        cBrain.isQuarantined = true
        
        updateButtons()
    }
    
	//Leslie called dib on this
    func beginInfection() {
        print("beginning infection")
        cBrain.isInfected = true //mark user infected
        //send data to the server to notify other users
        //start a quarantine
        beginQuarantine()

    }
    
    //LESLIE
    func call911() {
        print("Im calling 911")
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
    
    func userRecovered() {
        
    }
    
    func quarantineEnded() { //may need to make this an @objc function
        
    }
    
    @objc func updateCounter() {
        //qLabel2.text = "Days Left: " + cBrain.daysLeft
    }
    
    @objc func countdownCompleted() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get userdefaults into struct
        
        //home1Label.text = vComp.status.rawValue
        
        updateButtons()
        
//        home1Label.text = statusLabels.healthy.rawValue
//
//        blueButton.setTitle( "Begin Quarantine" , for: .normal )
//        blueButton.isHidden = false
//
//        qLabel1.isHidden = true
//        qLabel2.isHidden = true
        

        //add our notifications
//        NotificationCenter.default.addObserver(self, selector: #selector(updateCounter),
//                                               name: QuarantineBrain.qCounterUpdated,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(countdownCompleted),
//                                               name: QuarantineBrain.qCounterFinished,
//                                               object: nil)
    }
    
}
