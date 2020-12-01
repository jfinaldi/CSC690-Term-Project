//
//  QuarantineBrain.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/30/20.
//

import Foundation
import UIKit

class QuarantineBrain {
    
//    static let qCounterFinished = Notification.Name("QuarantineBrain.qCounterFinished")
//
//    let seconds: TimeInterval = 1209600
//    let secondsPerDay: Double = 86400
//
//    var daysLeft: Int?
//    var secondsLeft: TimeInterval?
//    var timer: Timer?
//
//    func startCountdown() {
//
//
//        //countdown the specific number
//        //notify that the counter has decremented
//        //notify that days have changed
//        //notify that hours have changed
//        //notify that minutes have changed
//        //notify that seconds have changed
//        //if everything goes to 0, notify that the counter has finished
//            //invalidate the timer
//
//        secondsLeft = self.seconds
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) -> Void in
//            guard let secondsLeft = self.secondsLeft else {
//                return
//            }
//            let newSeconds = secondsLeft - 1
//
//            if newSeconds >= 0 {
//                self.secondsLeft = newSeconds
//                let dL: Double = newSeconds / self.secondsPerDay //derive the days in doubles
//                self.daysLeft = Int(dL) //truncate and save as integer
//                //Notify that seconds have changed
//                NotificationCenter.default.post(name: QuarantineBrain.qCounterUpdated, object: nil)
//            }
//            if newSeconds == 0 {
//                print("Done!")
//                NotificationCenter.default.post(name: QuarantineBrain.qCounterFinished, object: nil)
//                timer.invalidate()
//            }
//        })
//    }
}

