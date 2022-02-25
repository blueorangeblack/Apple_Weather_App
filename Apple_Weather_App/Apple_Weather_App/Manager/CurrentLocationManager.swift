//
//  CoreLocationManager.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/21.
//

import CoreLocation
import Foundation

struct CurrentLocationManager {
    static let manager = CLLocationManager()
    static var currentLocation: City?
    
    static func checkLocationAuthorizationStatus() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }
        
        switch manager.authorizationStatus {
        case .notDetermined:
            CurrentLocationManager.manager.requestWhenInUseAuthorization()
        case .restricted, .denied, .authorizedAlways, .authorizedWhenInUse:
            return
        @unknown default:
            print("AuthorizationStatus unknown case")
        }
    }
    
    static func getCurrentLocation(completion: @escaping (Bool) -> Void) {
        CurrentLocationManager.manager.startUpdatingLocation()
        guard let coordinate = CurrentLocationManager.manager.location?.coordinate else { return }
        CurrentLocationManager.manager.stopUpdatingLocation()
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("reverse geodcode fail: \(error.localizedDescription)")
                return
            }
            
            guard let placemarks = placemarks, !placemarks.isEmpty else { return }
            
            let placemark = placemarks[0]
            let locality = placemark.locality
            let subLocality = placemark.subLocality
            let name = placemark.name
            
            let city = City(name: locality ?? subLocality ?? name ?? "", latitude: coordinate.latitude, longitude: coordinate.longitude)
            currentLocation = city
            
            completion(true)
        }
    }
}
