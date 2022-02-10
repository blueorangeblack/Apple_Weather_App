//
//  CurrentWeatherManager.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/10.
//

import Foundation

struct CurrentWeatherManager {
    private let scheme = "https"
    private let host = "api.openweathermap.org"
    private let path = "/data/2.5/weather"
    private let queryItems = [
        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "lang", value: "kr"),
        URLQueryItem(name: "appid", value: "0f158f76db5b186912f2139b8612082c")
    ]
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        urlComponents.queryItems?.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlComponents.queryItems?.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        
        guard let requestURL = urlComponents.url else { return }
        print(requestURL)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: data) else { return }
            
            switch response.statusCode {
            case 200..<300:
                completion(currentWeather)
            case 400..<500:
                print("ERROR: client error \(response.statusCode)")
            case 500..<600:
                print("ERROR: server error \(response.statusCode)")
            default:
                print("ERROR: \(response.statusCode)")
            }
        }
        dataTask.resume()
    }
}
