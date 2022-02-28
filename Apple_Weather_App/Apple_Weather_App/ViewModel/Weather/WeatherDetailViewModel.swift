//
//  WeatherDetailViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/14.
//

import UIKit

struct WeatherDetailViewModel {
    let backViewTrailingConstant: CGFloat
    let backViewLeadingConstant: CGFloat
    let title: String
    let detail: String
    let subDetail: String?
    
    init(currentWeather: CurrentWeather, index: Int, timezone: Int, tomorrowSunrise: Date, tomorrowSunset: Date) {
        if index % 2 == 0 {
            backViewTrailingConstant = -5
            backViewLeadingConstant = 0
        } else {
            backViewTrailingConstant = 0
            backViewLeadingConstant = 5
        }
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.timeZone = TimeZone(secondsFromGMT: currentWeather.timezone)
        dateformatter.timeStyle = .short
        
        switch index {
        case 0:
            let now = Date()
            if currentWeather.sun.sunrise > now {
                self.title = "일출"
                self.detail = dateformatter.string(from: currentWeather.sun.sunrise)
                self.subDetail = "일몰: \(dateformatter.string(from: currentWeather.sun.sunset))"
            } else if now < currentWeather.sun.sunset {
                self.title = "일몰"
                self.detail = dateformatter.string(from: currentWeather.sun.sunset)
                self.subDetail = "일출: \(dateformatter.string(from: currentWeather.sun.sunrise))"
            } else {
                self.title = "일출"
                self.detail = dateformatter.string(from: tomorrowSunrise)
                self.subDetail = "일몰: \(dateformatter.string(from: tomorrowSunset))"
            }
        case 1:
            self.title = "바람"
            self.detail = "\(Int(currentWeather.windSpeed))m/s"
            self.subDetail = nil
        case 2:
            self.title = "체감 온도"
            self.detail = currentWeather.feelsLike.tempString()
            self.subDetail = nil
        case 3:
            self.title = "습도"
            self.detail = "\(currentWeather.humidity)%"
            self.subDetail = nil
        case 4:
            self.title = "가시거리"
            self.detail = "\(currentWeather.visibility / 1000)km"
            self.subDetail = nil
        case 5:
            self.title = "기압"
            self.detail = "\(currentWeather.pressure)hPa"
            self.subDetail = nil
        default:
            self.title = ""
            self.detail = ""
            self.subDetail = nil
        }
    }
}
