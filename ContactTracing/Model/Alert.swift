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
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {ACTION in
            if let url = URL(string: "https://youtu.be/14ss61V5lL0"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}
