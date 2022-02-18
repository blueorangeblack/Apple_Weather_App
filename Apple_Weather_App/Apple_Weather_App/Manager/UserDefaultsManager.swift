//
//  CityManager.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/17.
//

import Foundation

struct UserDefaultsManager {
    static var citiesKey = "cities"
    static var cities = [City]()
    
    static func getCities() {
        guard let data = UserDefaults.standard.value(forKey: citiesKey) as? Data,
              let cities = try? JSONDecoder().decode([City].self, from: data) else { return }

        UserDefaultsManager.cities = cities
    }
    
    func addCity(_ city: City) {
        UserDefaultsManager.cities.append(City(name: city.name, latitude: city.latitude, longitude: city.longitude))
        UserDefaults.standard.set(try? JSONEncoder().encode(UserDefaultsManager.cities), forKey: UserDefaultsManager.citiesKey)
    }
}
