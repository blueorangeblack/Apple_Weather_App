//
//  WeatherManager.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/10.
//

import Foundation

struct WeatherManager {
    private let scheme = "https"
    private let host = "api.openweathermap.org"
    private let queryItems = [
        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "lang", value: "kr"),
        URLQueryItem(name: "appid", value: "0f158f76db5b186912f2139b8612082c")
    ]
    let cityName: String
    let latitude: Double
    let longitude: Double
    
    func fetchWeather(completion: @escaping (Weather) -> Void) {
        let dispatchGroup = DispatchGroup()
        var currentWeather: CurrentWeather?
        var forecast: Forecast?
        
        dispatchGroup.enter()
        fetchCurrentWeather(latitude: latitude, longitude: longitude) { result in
            currentWeather = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchForecast(latitude: latitude, longitude: longitude) { result in
            forecast = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            guard let currentWeather = currentWeather,
                  let forecast = forecast else { return }
            let weather = Weather(cityName: cityName, currentWeather: currentWeather, forecast: forecast)
            print(weather.forecast.hourly.count, "개")
            completion(weather)
        }
    }
    
    private func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        let path = "/data/2.5/weather"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        urlComponents.queryItems?.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlComponents.queryItems?.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        
        guard let requestURL = urlComponents.url else { return }
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
    
    private func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Forecast) -> Void) {
        let path = "/data/2.5/onecall"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        urlComponents.queryItems?.append(URLQueryItem(name: "exclude", value: "minutely"))
        urlComponents.queryItems?.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlComponents.queryItems?.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        
        guard let requestURL = urlComponents.url else { return }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let forecast = try? jsonDecoder.decode(Forecast.self, from: data) else { return }
            
            switch response.statusCode {
            case 200..<300:
                completion(forecast)
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
