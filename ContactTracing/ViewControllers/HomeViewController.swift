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
    var qStartDate: Date? = nil
    //let maxTimeLapsed: Double = 1209600.00
    let maxTimeLapsed: Double = 30.00
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
    
    func goGetTested() {
        print("go get tested!")
        if let url = URL(string: "https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/testing.html"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func updateQuarantineDays() {
        guard let days = cBrain.quarantineDaysLeft else {
            print("We don't have any quarantine days left")
            return
        }
        qLabel2.text = "Days Left: \(days)"
    }
    
    func beginQuarantine() {
        changeUserPhase(to: 2)
        
        cBrain.isQuarantined = true
        
        //pull current date, store in userdefaults
        qStartDate = Date()
        print(qStartDate)
        userDefaults.setValue(qStartDate, forKey: "qStart")
        
        //update daysLeft
        self.daysLeft = 14
        print(daysLeft)
        
        //update qLabel2
        qLabel2.text = "Days Left: \(daysLeft)"
        updateButtons()
    }
    
    func isQuarantineDoneYet() {
        //pull current date
        let curDay = Date()
        
        //if current day = quarantine end day
        guard qStartDate != nil else {
            return
        }
        let timeElapsed = curDay.timeIntervalSince(qStartDate!)
        print("Time elapsed: \(timeElapsed)")
        
        //find out if 14 days has elapsed
        if timeElapsed >= maxTimeLapsed {
            print("Quarantine is finished!")
            qTimerIsUp()//end quarantine
        }
        
        //update daysLeft
        self.daysLeft = Int(timeElapsed / 86400)
        print("Days left: \(daysLeft)")
        
        //update qLabel2
        qLabel2.text = "Days Left: \(daysLeft)"
        updateButtons()
    }
    
    func qTimerIsUp() {
        //set quarantine start date variable to nil
        qStartDate = nil
        userDefaults.setValue(qStartDate, forKey: "qStart")
        
        //change the user phase to 1
        changeUserPhase(to: 1)
        
        //call updateButtons
        updateButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isQuarantineDoneYet()
    }
    
	//Leslie called dib on this
    func beginInfection() {
        print("beginning infection")
        cBrain.isInfected = true //mark user infected
        
        //send data to the server to notify other users
		if let user = userDefaults.string(forKey: "username"),
		   let loginToken = userDefaults.string(forKey: "login_token"){
			DataModelServices().reportInfection(username: user, login_token: loginToken)
		} else {
			print("not logged in")
			performSegue(withIdentifier: "BackToLogin", sender: self)
		}
		
        //start a quarantine
        beginQuarantine()
		Alert.showBasicAlert(on: self, with: "You dumb dumb haven't been wearing mask ehh!?", message: "We have to notify bunch of unlucky bastards that they might have gotten covid now. You better stay inside and not fuck this up any further!!!")
    }
    
    //LESLIE
    func call911() {
        print("Im calling 911")
        
		Alert.showCallAlert(on: self, with: "Are you sure you want to call 911?", message: "There's no backing out if you tap yes.")
    }
    
    func userRecovered() {
        cBrain.isInfected = false
        qTimerIsUp() //nuke the quarantine
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
    
    //Map code attributed to link 2 in header
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Get the user's location and center the map around it
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        self.currentLocation = center
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map1.setRegion(mRegion, animated: true)

        // Get user's Current Location and Drop a pin
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        map1.addAnnotation(mkAnnotation)
        
        locationManager.stopUpdatingLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		overrideUserInterfaceStyle = .light
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //get user defaults
        userDefaults = UserDefaults.standard
        self.userPhase = userDefaults.integer(forKey: "userPhase")
        if userPhase == 0 { userPhase = 1 }
        self.qStartDate = userDefaults.object(forKey: "qStart") as? Date
        
        //Map code attributed to link 1 in header
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
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
