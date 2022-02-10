//
//  CurrentWeather.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/10.
//

import Foundation

struct CurrentWeather: Decodable {
    private let main: Main
    private let weatherDescription: [WeatherDescription]
    private let wind: Wind
    private let sun: Sun
    let visibility: Int
    
    var temp: Double {
        main.temp
    }
    
    var description: String {
        weatherDescription[0].weatherDescription
    }
    
    var tempMax: Double {
        main.tempMax
    }
    
    var tempMin: Double {
        main.tempMin
    }
    
    var feelsLike: Double {
        main.feelsLike
    }
    
    var pressure: Int {
        main.pressure
    }
    
    var humidity: Int {
        main.humidity
    }
    
    var windSpeed: Double {
        wind.speed
    }

    enum CodingKeys: String, CodingKey {
        case main, wind, visibility
        case weatherDescription = "weather"
        case sun = "sys"
    }
}

struct Main: Decodable {
    let temp: Double
    let tempMax: Double
    let tempMin: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case feelsLike = "feels_like"
    }
}

struct WeatherDescription: Decodable {
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}

struct Wind: Decodable {
    let speed: Double
}

struct Sun: Decodable {
    let sunrise: Int
    let sunset: Int
}
