//
//  QuarantineBrain.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/30/20.
//

import Foundation
import UIKit

class QuarantineBrain {
    
      // Create Obj -> USER:
    //            `username` -> string
    //            `password` -> string
    //            `login_token` // Save in user_def -> int
    //            `device_token`// Save in user_def -> string
                    
        // request params: username, pass, device_token
        // response: login_token
        
        // "https://localhost:4000/login"
        
        // Create Obj -> Location
    //        `user_id` -> int
    //        `latitude` -> Double
    //        `longtitude` -> Double
    //        `time` -> Date
    //        `infected` -> Bool
     
        //request params: username, login_token
         // response: [Location]
        
        // "https://localhost:4000/getLocations"
     
    //    {'latitude': Double,
    //    `longtitude`: Double,
    //    `time`: 'year/month/day/time',
    //    'infected': Bool
    //    }

}

