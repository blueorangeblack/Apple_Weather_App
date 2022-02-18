//
//  CurrentWeatherViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/12.
//

import Foundation

struct CurrentWeatherViewModel {
    let weather: Weather
    
    var cityName: String { return weather.city.name }
    
    var temp: String { return weather.currentWeather.temp.tempString() }
    
    var weatherDescription: String { return weather.currentWeather.id.weatherDescription() }
    
    var tempMaxMin: String {
        let daily = weather.forecast.daily[0]
        return "최고:\(daily.tempMax.tempString()) 최저:\(daily.tempMin.tempString())"
    }
}
