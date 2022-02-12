//
//  HourlyForecastViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/12.
//

import UIKit

struct HourlyForecastViewModel {
    let hourlyForecast: HourlyForecast
    
    var time: String {
        let now = Date()
        let time = hourlyForecast.dt
        if now > time {
            return "지금"
        } else {
            let dateformatter = DateFormatter()
            dateformatter.locale = Locale(identifier: "ko_KR")
            dateformatter.dateFormat = "a h시"
            return dateformatter.string(from: time)
        }
    }
    
    var image: UIImage { return hourlyForecast.id.weatherImage() }
    
    var pop: String {
        let pop = hourlyForecast.pop
        let id = hourlyForecast.id
        return pop.probabilityOfPrecipitation(id: id)
    }
    
    var temp: String { return hourlyForecast.temp.tempString() }
}
