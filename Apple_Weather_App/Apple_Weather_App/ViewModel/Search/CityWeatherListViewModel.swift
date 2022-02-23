//
//  CityWeatherListViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/17.
//

import Foundation

struct CityWeatherListViewModel {
    let weather: Weather
    
    var isEditing: Bool
    
    var cityName: String
    
    var time: String
    
    var weatherDescription: String { return weather.currentWeather.id.weatherDescription() }
    
    var temp: String { return weather.currentWeather.temp.tempString() }
    
    var tempMaxMin: String {
        let daily = weather.forecast.daily[0]
        return "최고:\(daily.tempMax.tempString()) 최저:\(daily.tempMin.tempString())"
    }
    
    init(weather: Weather, isEditing: Bool, isCurrentLocation: Bool) {
        self.weather = weather
        self.isEditing = isEditing
        
        if isCurrentLocation {
            self.cityName = "나의 위치"
            self.time = weather.city.name
        } else {
            self.cityName = weather.city.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.currentWeather.timezone)
            dateFormatter.timeStyle = .short
            
            self.time = dateFormatter.string(from: Date())
        }
    }
}
