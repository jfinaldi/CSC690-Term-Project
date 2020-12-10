//
//  LocationObject.swift
//  ContactTracing
//
//  Created by Wameedh Mohammed Ali on 12/7/20.
//

import Foundation

struct LocationObject: Codable {
    // Create Obj -> Location
    //        `user_id` -> int
    //        `latitude` -> Double
    //        `longtitude` -> Double
    //        `time` -> Date
    //        `infected` -> Bool
    
    let latitude: Double
    let longtitude: Double
    let time: String
    let infected: Int
    
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longtitude = "longtitude"
        case infected = "infected"
        case time = "time"
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longtitude = try values.decode(Double.self, forKey: .longtitude)
        time = try values.decode(String.self, forKey: .time)
        infected = try values.decode(Int.self, forKey: .infected)
    }
    
    
    //formatter.dateFormat = "HH:mm E, d MMM y"
    
    func getDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        if let date = dateFormatter.date(from: time)  {
            return date
        } else{
            return nil
        }
    }
    
}
