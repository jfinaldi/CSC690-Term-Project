//
//  UserObject.swift
//  ContactTracing
//
//  Created by Wameedh Mohammed Ali on 12/3/20.
//

import Foundation

struct User {
    // Create Obj -> USER:
       //            `username` -> string
       //            `password` -> string
       //            `login_token` // Save in user_def -> int
       //            `device_token`// Save in user_def -> string
    
    let username: String
    let password: String
    var device_token: String
    var login_token: Int
        
}

struct Location {
    // Create Obj -> Location
    //        `user_id` -> int
    //        `latitude` -> Double
    //        `longtitude` -> Double
    //        `time` -> Date
    //        `infected` -> Bool
    
    let user_id: Int
    let latitude: Double
    let longtitude: Double
    let time: Data
    let infected: Bool
    

}
