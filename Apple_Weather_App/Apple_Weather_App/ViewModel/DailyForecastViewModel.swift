//
//  DailyForecastViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/13.
//

import UIKit

struct DailyForecastViewModel {
    let dailyForecast: DailyForecast
    
    var day: String
    var image: UIImage
    var pop: String
    var tempMinString: String
    var tempMaxString: String
    var dayilyMinTemp: Int
    var dayilyMaxTemp: Int
    var weeklyMinTemp: Int
    var weeklyMaxTemp: Int
    
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
        self.pop = pop.probabilityOfPrecipitation(id: id)
        
        self.tempMinString = dailyForecast.tempMin.tempString()
        self.tempMaxString = dailyForecast.tempMax.tempString()
        
        self.dayilyMinTemp = Int(dailyForecast.tempMin)
        self.dayilyMaxTemp = Int(dailyForecast.tempMax)
        
        self.weeklyMinTemp = weeklyMinTemp
        self.weeklyMaxTemp = weeklyMaxTemp
    }
}
