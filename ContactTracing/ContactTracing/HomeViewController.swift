//
//  HomeViewController.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var home1Label: UILabel!
    @IBOutlet weak var home2Label: UILabel!
    @IBOutlet weak var home3Label: UILabel!
    
//    @IBOutlet weak var map1: MKMapView!
//    @IBOutlet weak var map2: MKMapView!
//    @IBOutlet weak var map3: MKMapView!
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    @IBAction func infectedButtonClicked(_ sender: Any) {
    }
    
    @IBAction func getTestedClicked(_ sender: Any) {
    }
    
    @IBAction func beginQuarantineClicked(_ sender: Any) {
    }
    
    @IBAction func call911Clicked(_ sender: Any) {
    }
    
    @IBAction func recoveryClicked(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
