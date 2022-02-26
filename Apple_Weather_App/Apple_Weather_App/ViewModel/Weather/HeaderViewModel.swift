//
//  HeaderViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/14.
//

import UIKit

struct HeaderViewModel {
    let title: String
    let weatherColor: UIColor
    
    init(section: Int, weatherColor: UIColor) {
        if section == 1 {
            self.title = "시간별 일기예보"
        } else if section == 2 {
            self.title = "8일간의 일기예보"
        } else {
            self.title = ""
        }
        
        self.weatherColor = weatherColor
    }
}
