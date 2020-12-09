//
//  HomeViewController.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//  Map related code attributed to the following links:
//  https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
//  https://medium.com/@kiransjadhav111/corelocation-map-kit-get-the-users-current-location-set-a-pin-in-swift-edb12f9166b2
//
import CoreLocation
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

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var home1Label: UILabel!
    @IBOutlet weak var qLabel1: UILabel!
    @IBOutlet weak var qLabel2: UILabel!
    
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    var userPhase = 1 //1 for healthy, 2 for at risk, 3 for infected
    var daysLeft: Int = 14
    //var vComp = ViewComponents(redButton: redButtons.infected, greenButton: greenButtons.tested, status: statusLabels.healthy)
    
    let locationManager = CLLocationManager()
    let cBrain = ContactTracingBrain()
    let qBrain = QuarantineBrain()
    var userDefaults = UserDefaults.standard
    var currentLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var map1: MKMapView!
    
    let MapView: MKMapView = {
        let map = MKMapView()
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isUserInteractionEnabled = true
        return map

    }()
    
    @IBAction func redButtonClicked(_ sender: Any) {
        print("red button clicked")
        print("userPhase: \(userPhase)")
        
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
        
        //save to userdefaults
        self.userDefaults.set(userPhase, forKey: "userPhase")
        
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
    
    @objc func outputNotification() {
        let alert = UIAlertController(title: "YOU ARE AT RISK", message: "It is highly advised to start quarantine procedures asap", preferredStyle: .alert)
        self.present(alert, animated: true)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
    }
    
    //Map code attributed to link 1 in header
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentLocation = locValue
    
    
        //Map code attributed to link 2 in header
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map1.setRegion(mRegion, animated: true)

        //Map code attributed to link 2 in header
        // Get user's Current Location and Drop a pin
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        map1.addAnnotation(mkAnnotation)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //get user defaults
        userDefaults = UserDefaults.standard
        self.userPhase = userDefaults.integer(forKey: "userPhase")
        if userPhase == 0 { userPhase = 1 }
        
        //Map code attributed to link 1 in header
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
            //locationManager.requestLocation()
        }
        map1.setCenter(self.currentLocation, animated: false)
        
        
        //check the quarantine days left
        //daysLeft
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(outputNotification),
                                               name: AppDelegate.dangerMessage,
                                               object: nil)
    }

    
}
