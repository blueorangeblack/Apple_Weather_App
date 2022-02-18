//
//  HeaderViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/14.
//

import Foundation

struct HeaderViewModel {
    var title: String
    
    init(section: Int) {
        if section == 1 {
            self.title = "시간별 일기예보"
        } else if section == 2 {
            self.title = "8일간의 일기예보"
        } else {
            self.title = ""
        }
    }
}
