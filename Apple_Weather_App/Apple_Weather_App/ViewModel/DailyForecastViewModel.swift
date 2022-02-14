//
//  DailyForecastViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/13.
//

import UIKit

struct DailyForecastViewModel {
    let dailyForecast: DailyForecast
    
    let day: String
    let image: UIImage
    let pop: String
    let tempMinString: String
    let tempMaxString: String
    let dailyMinTemp: Int
    let dailyMaxTemp: Int
    let weeklyMinTemp: Int
    let weeklyMaxTemp: Int
    
    init(dailyForecast: DailyForecast, index: Int, timezone: Int, weeklyMinTemp: Int, weeklyMaxTemp: Int) {
        self.dailyForecast = dailyForecast
        
        if index == 0 {
            self.day = "오늘"
        } else {
            let date = dailyForecast.dt
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
            dateFormatter.dateFormat = "E"
            self.day = dateFormatter.string(from: date)
        }
        
        self.image = dailyForecast.id.weatherImage()
        
        let pop = dailyForecast.pop
        let id = dailyForecast.id
        self.pop = pop.probabilityOfPrecipitation(for: id)
        
        self.tempMinString = dailyForecast.tempMin.tempString()
        self.tempMaxString = dailyForecast.tempMax.tempString()
        
        self.dailyMinTemp = Int(dailyForecast.tempMin)
        self.dailyMaxTemp = Int(dailyForecast.tempMax)
        
        self.weeklyMinTemp = weeklyMinTemp
        self.weeklyMaxTemp = weeklyMaxTemp
    }
}
