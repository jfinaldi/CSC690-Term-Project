//
//  UserObject.swift
//  ContactTracing
//
//  Created by Wameedh Mohammed Ali on 12/3/20.
//

import Foundation

struct User: Codable {
    // Create Obj -> USER:
    //            `username` -> string
    //            `password` -> string
    //            `login_token` // Save in user_def -> int
    //            `device_token`// Save in user_def -> string
    
    var username: String = ""
    var password: String = ""
    var device_token: String = ""
    var login_token: String
    
    var userDefaults = UserDefaults.standard
    
    
    init(username: String, password: String, device_token: String, login_token: String) {
        self.username = username
        self.password = password
        self.device_token = device_token
        self.login_token = login_token
    }
    
    enum CodingKeys: String, CodingKey {
        //case username = "username"
        //case device_token = "device_token"
        case login_token = "token"
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //username = try values.decode(String.self, forKey: .username)
        //device_token = try values.decode(String.self, forKey: .device_token)
        login_token = try values.decode(String.self, forKey: .login_token)
    }
    
    mutating func setPassword(pass: String) {
        self.password = pass
    }
    
    func saveLoginToken(login_token: String){
        self.userDefaults.set(login_token, forKey: "login_token")
    }
    
    func getLoginToken() -> String {
        if let token = self.userDefaults.string(forKey: login_token) {
            return token
        } else{
            return "NO TOKEN"
        }
       
    }
    
    
}
