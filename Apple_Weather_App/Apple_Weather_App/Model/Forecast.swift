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
    let dt: Date
    private let weatherDescription: [WeatherDescription]
    let pop: Double
    let temp: Double
    
    var id: String {
        weatherDescription[0].id
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, pop, temp
        case weatherDescription = "weather"
    }
}

struct DailyForecast: Decodable {
    let dt: Date
    private let weatherDescription: [WeatherDescription]
    let pop: Double
    private let temp: Temp
    
    var id: String {
        weatherDescription[0].id
    }
    
    var tempMax: Double {
        temp.tempMax
    }
    
    var tempMin: Double {
        temp.tempMin
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, pop, temp
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
