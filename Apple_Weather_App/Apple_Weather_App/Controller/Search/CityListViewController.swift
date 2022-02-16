//
//  CityListViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/09.
//

import MapKit
import UIKit

private let reuseID = "CityListCell"

class CityListViewController: UITableViewController {
    
    // MARK: - Properties
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: suggestionViewController)
        sc.searchResultsUpdater = suggestionViewController
        sc.searchBar.placeholder = "도시 또는 공항 검색"
        sc.searchBar.setValue("취소", forKey: "cancelButtonText")
        sc.searchBar.tintColor = .white
        sc.obscuresBackgroundDuringPresentation = true
        sc.searchBar.spellCheckingType = .no
        sc.searchBar.delegate = self
        return sc
    }()
    
    private lazy var suggestionViewController: SuggestionViewController = {
        let vc = SuggestionViewController()
        vc.tableView.delegate = self
        return vc
    }()
    
    private var newCityWeatherController: UINavigationController?
    
    private var newCityWeather: Weather?
    
    private lazy var cityWeatherList = [Weather]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .black
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "날씨"
        
        tableView.register(CityListCell.self, forCellReuseIdentifier: reuseID)
        
        view.addSubview(suggestionViewController.view)
        suggestionViewController.view.frame = self.view.frame
    }
    
    private func fetchWeather(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        searchRequest.region = MKCoordinateRegion(MKMapRect.world)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: { [weak self] response, error in
            if let error = error {
                let alert = UIAlertController(title: "Could not find any places.", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            } else {
                let place = response?.mapItems.first
//                print(place?.placemark.coordinate as Any)

                guard let cityName = self?.getPlaceName(for: place),
                      let latitude = place?.placemark.coordinate.latitude,
                      let longitude = place?.placemark.coordinate.longitude else { return }
                
                let weatherManager = WeatherManager(cityName: cityName, latitude: latitude, longitude: longitude)
                weatherManager.fetchWeather { [weak self] weather in
                    self?.newCityWeather = weather
                    self?.presentNewCityWeatherController()
                }
            }
        })
    }
    
    private func getPlaceName(for place: MKMapItem?) -> String {
        let locality = place?.placemark.locality
        let name = place?.name
        let subLocality = place?.placemark.subLocality
//        print(locality)
//        print(name)
//        print(subLocality)
//        print("==> \(locality ?? name ?? subLocality ?? "")")
//        print("----------")
        return locality ?? name ?? subLocality ?? ""
    }
    
    private func presentNewCityWeatherController() {
        guard let newCityWeather = newCityWeather else { return }
        
        let vc = WeatherViewController(weather: newCityWeather)
        newCityWeatherController = UINavigationController(rootViewController: vc)
        
        guard let ncwc = newCityWeatherController else { return }
        
        ncwc.view.backgroundColor = dailySkyBlue
        ncwc.view.addSubview(vc.view)
        vc.view.frame = ncwc.view.frame
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        vc.navigationController?.navigationBar.standardAppearance = navBarAppearance
        vc.navigationController?.navigationBar.isTranslucent = false
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))

        present(ncwc, animated: true, completion: nil)
    }
    
    func dismissAndResetNewCityWeather() {
        guard let ncwc = newCityWeatherController else { return }
        ncwc.dismiss(animated: true)
        newCityWeatherController = nil
        newCityWeather = nil
    }
    
    func dismissSuggestionAndResetSearchBar() {
        suggestionViewController.dismiss(animated: true, completion: nil)
        searchController.searchBar.text = nil
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonTapped() {
        dismissAndResetNewCityWeather()
    }
    
    @objc func addButtonTapped() {
        guard let newCityWeather = newCityWeather else { return }
        cityWeatherList.append(newCityWeather)
        dismissSuggestionAndResetSearchBar()
        dismissAndResetNewCityWeather()
    }
}

// MARK: - UISearchBarDelegate

extension CityListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension CityListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = cityWeatherList[indexPath.row].cityName
        content.textProperties.color = .white
        cell.contentConfiguration = content
        cell.backgroundColor = .black
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CityListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == suggestionViewController.tableView,
           let suggestion = suggestionViewController.completerResults?[indexPath.row] {
            fetchWeather(for: suggestion)
        }
    }
}
