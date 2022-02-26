//
//  Extensions.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/12.
//

import UIKit

extension Double {
    /// Double type의 온도를 String type으로 변환
    /// - Returns: 온도(°)
    func tempString() -> String {
        return UserDefaultsManager.isFahrenheit ? "\(String(Int(self * 9 / 5 + 32)))°" : "\(String(Int(self)))°"
    }
    
    /// 비와 관련된 id이고, 강수확률이 10%보다 높을 경우 10단위로 강수확률을 나타냄
    /// - Parameter id: weatherID
    /// - Returns: 강수확률(%) (20% ~ 100%)
    func probabilityOfPrecipitation(for id: String) -> String {
        let rainIDs = ["09d", "09n", "10d", "10n", "11d", "11n", "13d", "13n"]
        
        if rainIDs.contains(id) && self > 0.1 {
            let num: Int = Int((Double(String(format: "%.1f", self)) ?? 0) * 100)
            return "\(num)%"
        } else {
            return ""
        }
    }
}

extension String {
    /// weatherID에 해당하는 간단한 날씨 설명
    /// - Returns: 간단한 날씨 설명
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
    
    /// weatherID에 해당하는 날씨 아이콘 이미지
    /// - Returns: 날씨 아이콘 이미지
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
    
    /// weatherID에 해당하는 날씨 색
    /// - Returns: 날씨 색
    func weatherColor() -> UIColor {
        switch self {
        case "01d", "02d": return d0102
        case "01n", "02n": return n0102
        case "03d": return d03
        case "03n": return n03
        case "04d": return d04
        case "04n": return n04
        case "09d", "10d", "11d": return d091011
        case "09n", "10n", "11n": return n091011
        case "13d": return d13
        case "13n": return n13
        case "50d": return d50
        case "50n": return n50
        default: return d0102
        }
    }
}
