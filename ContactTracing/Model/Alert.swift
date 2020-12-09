//
//  Alert.swift
//  TipCalculator
//
//  Created by Leslie Zhou on 10/24/20.
//

import Foundation
import UIKit

struct Alert {
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
	
	static func showCallAlert(on vc: UIViewController, with title: String, message: String){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {ACTION in
			if let url = URL(string: "https://youtu.be/Tt7bzxurJ1I"){
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}))
		alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
		vc.present(alert, animated: true, completion: nil)
	}
}
