//
//  WeatherDetailViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/14.
//

import UIKit

struct WeatherDetailViewModel {
    let currentWeather: CurrentWeather
    let backViewTrailingConstant: CGFloat
    
    init(currentWeather: CurrentWeather, index: Int, timezone: Int) {
        self.currentWeather = currentWeather
        if index % 2 == 0 {
            backViewTrailingConstant = -10
        } else {
            backViewTrailingConstant = 0
        }
    }
}
