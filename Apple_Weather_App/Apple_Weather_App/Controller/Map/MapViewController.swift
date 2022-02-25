//
//  MapViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/24.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    var cityWeatherList = [Weather]()
    
    private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.56826, longitude: 126.977829),
            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 100))
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("완료", for: .normal)
        btn.backgroundColor = .secondarySystemGroupedBackground
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupRegion()
        addAnnotations()
    }
    
    // MARK: - Helpers
    
    private func configure() {
        [mapView, doneButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            doneButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
            doneButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 10),
            doneButton.widthAnchor.constraint(equalToConstant: 80),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupRegion() {
        guard !cityWeatherList.isEmpty else { return }
        
        let city = cityWeatherList[0].city
        
        mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude),
            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 100))
    }
    
    func addAnnotations() {
        guard !cityWeatherList.isEmpty else { return }
        
        if CurrentLocationManager.currentLocation != nil {
            let currentLocation = cityWeatherList.removeFirst()
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: currentLocation.city.latitude, longitude: currentLocation.city.longitude)
            annotation.title = "나의 위치\n\(currentLocation.currentWeather.temp.tempString())"
            mapView.addAnnotation(annotation)
        }
        
        cityWeatherList.forEach {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.city.latitude, longitude: $0.city.longitude)
            annotation.title = "\($0.city.name)\n\($0.currentWeather.temp.tempString())"
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - Actions
    
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
