//
//  SuggestionViewModel.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/17.
//

import Foundation
import MapKit

struct SuggestionViewModel {
    let completerResult: MKLocalSearchCompletion
    
    var result: String {
        return "\(completerResult.title) \(completerResult.subtitle)"
    }
}
