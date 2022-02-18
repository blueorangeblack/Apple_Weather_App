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
    let dailyX1: CGFloat
    let dailyX2: CGFloat
    let strokeColor: CGColor
    
    init(dailyForecast: DailyForecast, index: Int, timezone: Int, weeklyMinTemp weeklyMin: Int, weeklyMaxTemp weeklyMax: Int) {
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
        
        let dailyMin = Int(dailyForecast.tempMin)
        let dailyMax = Int(dailyForecast.tempMax)
        let weeklyRange = weeklyMax - weeklyMin
        
        self.dailyX1 = CGFloat((dailyMin - weeklyMin) * 100 / weeklyRange)

        if dailyMax == weeklyMax {
            self.dailyX2 = 100
        } else {
            self.dailyX2 = CGFloat(100 / weeklyRange * (weeklyRange - (weeklyMax - dailyMax)))
        }
        
        if dailyMax < 0 {
            strokeColor = dailyBlue.cgColor
        } else if dailyMax < 10 {
            strokeColor = dailySkyBlue.cgColor
        } else if dailyMax < 20 {
            strokeColor = dailyYellow.cgColor
        } else {
            strokeColor = dailyOrange.cgColor
        }
    }
}
