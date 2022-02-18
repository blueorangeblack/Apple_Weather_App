//
//  City.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/17.
//

import Foundation

struct City: Codable, Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
