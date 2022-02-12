//
//  Extensions.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/12.
//

import UIKit

extension Double {
    func tempString() -> String {
        return "\(String(Int(self)))°"
    }
    
    func probabilityOfPrecipitation(id: String) -> String {
        let rainIDs = ["09d", "09n", "10d", "10n", "11d", "11n", "13d", "13n"]
        
        if self > 0.1 && rainIDs.contains(id) {
            let num: Int = Int((Double(String(format: "%.1f", self)) ?? 0) * 100)
            return "\(num)%"
        } else {
            return ""
        }
    }
}

extension String {
    func weatherDescription() -> String {
        switch self {
        case "01d": return "맑음"
        case "01n": return "청명함"
        case "02d": return "대체로 맑음"
        case "02n": return "대체로 청명함"
        case "03d", "03n": return "한때 흐림"
        case "04d", "04n": return "흐림"
        case "09d", "09n": return "소나기"
        case "10d", "10n": return "비"
        case "11d", "11n": return "뇌우"
        case "13d", "13n": return "눈"
        case "50d", "50n": return "안개"
        default: return ""
        }
    }
    
    func weatherImage() -> UIImage {
        var imageName = ""
        
        switch self {
        case "01d", "02d": imageName = "sun.max.fill"
        case "01n", "02n": imageName = "moon.stars.fill"
        case "03d": imageName = "cloud.sun.fill"
        case "03n": imageName = "cloud.moon.fill"
        case "04d", "04n": imageName = "cloud.fill"
        case "09d", "09n", "10d", "10n": imageName = "cloud.rain.fill"
        case "11d", "11n": imageName = "cloud.bolt.rain.fill"
        case "13d", "13n": imageName = "snow"
        case "50d", "50n": imageName = "sun.haze.fill"
        default: imageName = ""
        }
        
        return UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
    }
}
