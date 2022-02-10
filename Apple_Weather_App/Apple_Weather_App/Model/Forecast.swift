//
//  Forecast.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/10.
//

import Foundation

struct Forecast: Decodable {
    let hourly: [HourlyForecast]
    let daily: [DailyForecast]
}

struct HourlyForecast: Decodable {
    let dt: Int
    private let weatherDescription: [WeatherDescription]
    let temp: Double
    
    var description: String {
        weatherDescription[0].weatherDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, temp
        case weatherDescription = "weather"
    }
}

struct DailyForecast: Decodable {
    let dt: Int
    private let weatherDescription: [WeatherDescription]
    private let temp: Temp
    
    var description: String {
        weatherDescription[0].weatherDescription
    }
    
    var tempMax: Double {
        temp.tempMax
    }
    
    var tempMin: Double {
        temp.tempMin
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, temp
        case weatherDescription = "weather"
    }
}

struct Temp: Decodable {
    let tempMax: Double
    let tempMin: Double
    
    enum CodingKeys: String, CodingKey {
        case tempMax = "max"
        case tempMin = "min"
    }
}
