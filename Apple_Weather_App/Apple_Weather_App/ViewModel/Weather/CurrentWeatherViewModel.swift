//
//  CurrentWeatherViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/12.
//

import Foundation

struct CurrentWeatherViewModel {
    let cityName: String
    let temp: String
    let weatherDescription: String
    let tempMaxMin: String
    
    init(weather: Weather) {
        self.cityName = weather.city.name
        self.temp = weather.currentWeather.temp.tempString()
        self.weatherDescription = weather.currentWeather.id.weatherDescription()
        
        let daily = weather.forecast.daily[0]
        self.tempMaxMin = "최고:\(daily.tempMax.tempString())  최저:\(daily.tempMin.tempString())"
    }
}
