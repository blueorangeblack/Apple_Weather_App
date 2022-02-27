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
        URLQueryItem(name: "appid", value: "0f158f76db5b186912f2139b8612082c")
    ]
    
    func fetchCityWeatherList(completion: @escaping (Result<[Weather]?, WeatherError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var cityWeatherList = [Weather]()
        var error: WeatherError?
        
        UserDefaultsManager.cities.forEach {
            dispatchGroup.enter()
            fetchWeather(city: $0) { result in
                switch result {
                case .failure(let err):
                    error = err
                    dispatchGroup.leave()
                case .success(let weather):
                    cityWeatherList.append(weather)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = error {
                completion(.failure(error))
                return
            }
            
            cityWeatherList.sort(by: compareWithCitiesIndex)
            if let currentLoction = CurrentLocationManager.currentLocation {
                fetchWeather(city: currentLoction) { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let weather):
                        cityWeatherList.insert(weather, at: 0)
                        completion(.success(cityWeatherList))
                    }
                }
            } else {
                completion(.success(cityWeatherList))
            }
        }
    }
    
    func fetchWeather(city: City, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        var currentWeather: CurrentWeather?
        var forecast: Forecast?
        
        fetchCurrentWeather(latitude: city.latitude, longitude: city.longitude) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let cw):
                currentWeather = cw
                fetchForecast(latitude: city.latitude, longitude: city.longitude) { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let fo):
                        forecast = fo
                        guard let currentWeather = currentWeather,
                              let forecast = forecast else { return }
                        let city = City(name: city.name, latitude: city.latitude, longitude: city.longitude)
                        let weather = Weather(city: city,
                                              currentWeather: currentWeather,
                                              forecast: forecast)
                        completion(.success(weather))
                    }
                }
            }
        }
    }
    
    private func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, WeatherError>) -> Void) {
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
            
            guard let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200..<300:
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                guard error == nil,
                      let data = data,
                      let currentWeather = try? jsonDecoder.decode(CurrentWeather.self, from: data) else { return }
                completion(.success(currentWeather))
            case 300..<400:
                completion(.failure(.redirection))
                print("ERROR: fetchCurrentWeather - redirection \(response.statusCode)")
            case 429:
                completion(.failure(.tooManyRequests))
                print("ERROR: fetchCurrentWeather - too many requests \(response.statusCode)")
            case 400..<500:
                completion(.failure(.clientError))
                print("ERROR: fetchCurrentWeather - client error \(response.statusCode)")
            case 500..<600:
                completion(.failure(.serverError))
                print("ERROR: fetchCurrentWeather - server error \(response.statusCode)")
            default:
                completion(.failure(.unknownResponse))
                print("ERROR: fetchCurrentWeather - unknown response \(response.statusCode)")
            }
        }
        dataTask.resume()
    }
    
    private func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Result<Forecast, WeatherError>) -> Void) {
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
            
            guard let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200..<300:
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                guard error == nil,
                      let data = data,
                      let forecast = try? jsonDecoder.decode(Forecast.self, from: data) else { return }
                completion(.success(forecast))
            case 300..<400:
                completion(.failure(.redirection))
                print("ERROR: fetchForecast - redirection \(response.statusCode)")
            case 429:
                completion(.failure(.tooManyRequests))
                print("ERROR: fetchForecast - too many requests \(response.statusCode)")
            case 400..<500:
                completion(.failure(.clientError))
                print("ERROR: fetchForecast - client error \(response.statusCode)")
            case 500..<600:
                completion(.failure(.serverError))
                print("ERROR: fetchForecast - server error \(response.statusCode)")
            default:
                completion(.failure(.unknownResponse))
                print("ERROR: fetchForecast - unknown response \(response.statusCode)")
            }
        }
        dataTask.resume()
    }
    
    private func compareWithCitiesIndex(w1: Weather, w2: Weather) -> Bool {
        let w1Index: Int = UserDefaultsManager.cities.firstIndex(of: w1.city) ?? 0
        let w2Index: Int = UserDefaultsManager.cities.firstIndex(of: w2.city) ?? 0
        return w1Index < w2Index
    }
}

enum WeatherError: Error {
    case redirection
    case tooManyRequests
    case clientError
    case serverError
    case unknownResponse
    
    var title: String { return "ERROR" }
    
    var message: String {
        switch self {
        case .redirection:
            return "Redirection"
        case .tooManyRequests:
            return "Too Many Requests"
        case .clientError:
            return "Client Error"
        case .serverError:
            return "Server Error"
        case .unknownResponse:
            return "Unknown Response"
        }
    }
}
