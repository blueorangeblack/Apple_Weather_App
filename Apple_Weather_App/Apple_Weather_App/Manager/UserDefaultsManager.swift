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
    static var tempUnitKey = "tempUnit"
    static var isFahrenheit = false
    
    // MARK: City
    
    static func getCities() {
        guard let data = UserDefaults.standard.value(forKey: citiesKey) as? Data,
              let cities = try? JSONDecoder().decode([City].self, from: data) else { return }
        
        UserDefaultsManager.cities = cities
    }
    
    func addCity(_ city: City) {
        UserDefaultsManager.cities.append(City(name: city.name, latitude: city.latitude, longitude: city.longitude))
        saveCity()
    }
    
    func removeCity(_ index: Int) {
        var index = index
        
        if CurrentLocationManager.currentLocation != nil {
            index -= 1
        }
        
        UserDefaultsManager.cities.remove(at: index)
        saveCity()
    }
    
    func moveCity(sourceIndex: Int, destinationIndex: Int) {
        var sourceIndex = sourceIndex
        var destinationIndex = destinationIndex
        
        if CurrentLocationManager.currentLocation != nil {
            sourceIndex -= 1
            destinationIndex -= 1
        }
        
        let movedObject = UserDefaultsManager.cities.remove(at: sourceIndex)
        UserDefaultsManager.cities.insert(movedObject, at: destinationIndex)
        saveCity()
    }
    
    private func saveCity() {
        UserDefaults.standard.set(try? JSONEncoder().encode(UserDefaultsManager.cities), forKey: UserDefaultsManager.citiesKey)
    }
    
    // MARK: TempUnit
    
    static func getTempUnit() {
        UserDefaultsManager.isFahrenheit = UserDefaults.standard.bool(forKey: UserDefaultsManager.tempUnitKey)
    }
    
    func saveTempUnit(isFahrenheit: Bool) {
        UserDefaultsManager.isFahrenheit = isFahrenheit
        UserDefaults.standard.set(UserDefaultsManager.isFahrenheit, forKey: UserDefaultsManager.tempUnitKey)
    }
}
