//
//  CityWeatherListViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/17.
//

import UIKit

struct CityWeatherListViewModel {
    let weatherColor: UIColor
    let isEditing: Bool
    let cityName: String
    let time: String
    let weatherDescription: String
    let temp: String
    let tempMaxMin: String
    
    init(weather: Weather, isEditing: Bool, isCurrentLocation: Bool) {
        self.weatherColor = weather.currentWeather.id.weatherColor()
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
        
        self.weatherDescription = weather.currentWeather.id.weatherDescription()
        self.temp = weather.currentWeather.temp.tempString()
        
        let daily = weather.forecast.daily[0]
        self.tempMaxMin = "최고:\(daily.tempMax.tempString()) 최저:\(daily.tempMin.tempString())"
    }
}
