//
//  HourlyForecastViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/12.
//

import UIKit

struct HourlyForecastViewModel {
    let time: String
    let image: UIImage
    let pop: String
    let temp: String
    
    init(currentWeather: CurrentWeather, hourlyForecast: HourlyForecast) {
        let time = hourlyForecast.dt
        let now = Date()
        
        if time < now {
            self.time = "지금"
            self.image = currentWeather.id.weatherImage()
            self.pop = ""
            self.temp = currentWeather.temp.tempString()
        } else {
            let dateformatter = DateFormatter()
            dateformatter.locale = Locale(identifier: "ko_KR")
            dateformatter.timeZone = TimeZone(secondsFromGMT: currentWeather.timezone)
            dateformatter.dateFormat = "a h시"
            self.time = dateformatter.string(from: time)
            
            self.image = hourlyForecast.id.weatherImage()
            
            let pop = hourlyForecast.pop
            let id = hourlyForecast.id
            self.pop = pop.probabilityOfPrecipitation(for: id)
            
            self.temp = hourlyForecast.temp.tempString()
        }
    }
}
