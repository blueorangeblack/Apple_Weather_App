//
//  SuggestionViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/17.
//

import Foundation
import MapKit

struct SuggestionViewModel {
    let result: String
    
    init (completerResult: MKLocalSearchCompletion) {
        self.result = "\(completerResult.title) \(completerResult.subtitle)"
    }
}
