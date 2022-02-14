//
//  HourlyForecastViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/12.
//

import UIKit

struct HourlyForecastViewModel {
    let currentWeather: CurrentWeather
    let hourlyForecast: HourlyForecast
    
    let time: String
    let image: UIImage
    let pop: String
    let temp: String
    
    init(currentWeather: CurrentWeather, hourlyForecast: HourlyForecast) {
        self.currentWeather = currentWeather
        self.hourlyForecast = hourlyForecast
        
        let time = hourlyForecast.dt
        let now = Date()
        if time < now {
            self.time = "지금"
            self.temp = currentWeather.temp.tempString()
            self.image = currentWeather.id.weatherImage()
            self.pop = ""
        } else {
            let dateformatter = DateFormatter()
            dateformatter.locale = Locale(identifier: "ko_KR")
            dateformatter.timeZone = TimeZone(secondsFromGMT: currentWeather.timezone)
            dateformatter.dateFormat = "a h시"
            self.time = dateformatter.string(from: time)
            self.temp = hourlyForecast.temp.tempString()
            self.image = hourlyForecast.id.weatherImage()
            let pop = hourlyForecast.pop
            let id = hourlyForecast.id
            self.pop = pop.probabilityOfPrecipitation(for: id)
        }
    }
}
