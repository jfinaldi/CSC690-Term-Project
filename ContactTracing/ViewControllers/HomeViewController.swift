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

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var home1Label: UILabel!
    @IBOutlet weak var qLabel1: UILabel!
    @IBOutlet weak var qLabel2: UILabel!
    @IBOutlet weak var welcomeUser: UILabel!
    
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    var userPhase = 1 //1 for healthy, 2 for at risk, 3 for infected
    var daysLeft: Int = 14
    var qStartDate: Date? = nil
    let maxDays: Int = 14
    let secondsDivider: Double = 86400.00
    let maxTimeLapsed: Double = 1209600.00
    let timeLimit: Int = 120 // 2 min
    var locationCounter: Int = 0
    
    let locationManager = CLLocationManager()
    var userDefaults = UserDefaults.standard
    var currentLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var map1: MKMapView!
    
    let MapView: MKMapView = {
        let map = MKMapView()
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isUserInteractionEnabled = true
		map.showsUserLocation = true
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
    
    func beginQuarantine() {
        changeUserPhase(to: 2)
        
        //pull current date, store in userdefaults
        qStartDate = Date()
		print(qStartDate ?? "")
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
        self.daysLeft =  maxDays - Int(timeElapsed / secondsDivider)
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
        guard qStartDate != nil else {
            return
        }
        isQuarantineDoneYet()
    }
    
	//Leslie called dib on this
    func beginInfection() {
        print("beginning infection")
        
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
		Alert.showBasicAlert(on: self, with: "You dumb dumb haven't been wearing mask ehh!?", message: "We have to notify bunch of unlucky bastards that they might have gotten covid now. You better stay inside and not mess this up any further!!!")
    }
    
    //LESLIE
    func call911() {
        print("Im calling 911")
        
		Alert.showCallAlert(on: self, with: "Are you sure you want to call 911?", message: "There's no backing out if you tap yes.")
    }
    
    func userRecovered() {
        qTimerIsUp() //nuke the quarantine
    }
    
	@objc func outputNotification(notification: Notification) {
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

        // Get user's Current Location and Drop a pin
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        if locationCounter == 0 {
            map1.setRegion(mRegion, animated: true)
            map1.addAnnotation(mkAnnotation)
        }
        
        locationCounter = locationCounter + 1
        if locationCounter == timeLimit {
			print("location counter: \(locationCounter)")
            
            //send current location to the model to be stored
            if let name = userDefaults.string(forKey: "username"), let tok = userDefaults.string(forKey: "login_token"){
            DispatchQueue.global().async { [] in
                DataModelServices().logLocation(username: name, login_token: tok,
                                                latitude: mUserLocation.coordinate.latitude,
                                                longtitude: mUserLocation.coordinate.longitude,
                                                callback:{ () in })
                }
            }
            locationCounter = 0
        }
    }
	
	@objc func onNotification(notification: Notification) -> Void {
		print("huh")
		isQuarantineDoneYet()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		overrideUserInterfaceStyle = .light
		
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //get user defaults
        self.userPhase = userDefaults.integer(forKey: "userPhase")
        if userPhase == 0 { userPhase = 1 }
        self.qStartDate = userDefaults.object(forKey: "qStart") as? Date
        
        //drop all location pins on map
        if let loginToken = userDefaults.string(forKey: "login_token"), let username = userDefaults.string(forKey: "username") {
            DispatchQueue.global().async {
                DataModelServices().getLocation(username: username, login_token: loginToken) { [self] (res) in
                    res.locations.forEach { (location) in
                        let annotation = MKPointAnnotation()
                        let centerCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude:location.longtitude)
                        annotation.coordinate = centerCoordinate
                        map1.addAnnotation(annotation)
                    }
                }
            }
        } else {
            self.performSegue(withIdentifier: "BackToLogin", sender: self)
        }
        if let tempStr = userDefaults.string(forKey: "username") {
            welcomeUser.text = "Welcome, " + tempStr
        }
        
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
        
        updateButtons()
        
		NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: Notification.Name("checkDay"), object: nil)
    }

    
}
