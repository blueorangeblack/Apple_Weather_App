//
//  CityWeatherListViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/17.
//

import Foundation

struct CityWeatherListViewModel {
    let weather: Weather
    
    var cityName: String { return weather.city.name }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.currentWeather.timezone)
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date())
    }
    
    var weatherDescription: String { return weather.currentWeather.id.weatherDescription() }
    
    var temp: String { return weather.currentWeather.temp.tempString() }
    
    var tempMaxMin: String {
        let daily = weather.forecast.daily[0]
        return "최고:\(daily.tempMax.tempString()) 최저:\(daily.tempMin.tempString())"
    }
}
