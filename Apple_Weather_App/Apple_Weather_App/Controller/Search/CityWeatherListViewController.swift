//
//  CityWeatherListViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/09.
//

import MapKit
import UIKit

private let reuseID = "CityWeatherListCell"

class CityWeatherListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let weatherManager = WeatherManager()
    
    private let userDefaultsManager = UserDefaultsManager()
    
    private var cityWeatherList = [Weather]()
    
    private var newCityWeatherController: UINavigationController?
    
    private var newCityWeather: Weather?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CityWeatherListCell.self, forCellReuseIdentifier: reuseID)
        tableView.rowHeight = 125
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dragInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
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
    
    private lazy var suggestionViewController = SuggestionViewController()
    
    private lazy var rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: settingMenu)
    
    private lazy var settingMenu: UIMenu = {
        let menu = UIMenu(image: nil, identifier: nil, options: [.displayInline], children: [
            UIAction(title: "목록 편집", image: UIImage(systemName: "pencil"), handler: { [weak self] _ in
                self?.setEditMode()
            }),
            UIAction(title: "섭씨", image: UIImage(named: "Celsius"), state: .on, handler: { _ in
                print("섭씨")
            }),
            UIAction(title: "화씨", image: UIImage(named: "Fahrenheit"), state: .off, handler: { _ in
                print("화씨")
            })
        ])
        return menu
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchCityWeatherList()
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "날씨"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        suggestionViewController.tableView.delegate = self
        
        [tableView, suggestionViewController.view].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        suggestionViewController.view.frame = self.view.frame
        suggestionViewController.view.isHidden = true
    }
    
    private func setEditMode() {
        tableView.isEditing = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(editDone))
        navigationItem.rightBarButtonItem?.tintColor = .white
        tableView.reloadData()
    }
    
    private func fetchCityWeatherList() {
        weatherManager.fetchCityWeatherList { [weak self] cityWeatherList in
            self?.cityWeatherList = cityWeatherList
            self?.tableView.reloadData()
        }
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
                guard let place = response?.mapItems.first,
                      let cityName = self?.getPlaceName(for: place) else { return }
                let latitude = place.placemark.coordinate.latitude
                let longitude = place.placemark.coordinate.longitude
                
                let city = City(name: cityName, latitude: latitude, longitude: longitude)

                self?.weatherManager.fetchWeather(city: city) { weather in
                    self?.newCityWeather = weather
                    self?.presentNewCityWeatherController()
                }
            }
        })
    }
    
    private func getPlaceName(for place: MKMapItem) -> String {
        let locality = place.placemark.locality
        let name = place.name
        let subLocality = place.placemark.subLocality
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
        vc.navigationController?.navigationBar.tintColor = .white
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        
        let newCity = City(name: newCityWeather.city.name, latitude: newCityWeather.city.latitude, longitude: newCityWeather.city.longitude)
        UserDefaultsManager.cities.forEach {
            if $0 == newCity {
                vc.navigationItem.rightBarButtonItem = nil
            }
        }
        
        present(ncwc, animated: true, completion: nil)
    }
    
    private func dismissAndResetNewCityWeather() {
        guard let ncwc = newCityWeatherController else { return }
        ncwc.dismiss(animated: true)
        newCityWeatherController = nil
        newCityWeather = nil
    }
    
    private func dismissSuggestionAndResetSearchBar() {
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
        userDefaultsManager.addCity(newCityWeather.city)
        cityWeatherList.append(newCityWeather)
        tableView.reloadData()
        dismissSuggestionAndResetSearchBar()
        dismissAndResetNewCityWeather()
    }
    
    @objc func editDone() {
        tableView.isEditing = false
        navigationItem.rightBarButtonItem = rightBarButtonItem
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension CityWeatherListViewController: UISearchBarDelegate {
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

extension CityWeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? CityWeatherListCell else { return UITableViewCell() }
        cell.viewModel = CityWeatherListViewModel(weather: cityWeatherList[indexPath.row], isEditing: tableView.isEditing)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = cityWeatherList[sourceIndexPath.row]
        cityWeatherList.remove(at: sourceIndexPath.row)
        cityWeatherList.insert(movedObject, at: destinationIndexPath.row)
        userDefaultsManager.moveCity(sourceIndexPath: sourceIndexPath.row, destinationIndexPath: destinationIndexPath.row)
    }
}

// MARK: - UITableViewDelegate

extension CityWeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == suggestionViewController.tableView,
           let suggestion = suggestionViewController.completerResults?[indexPath.row] {
            fetchWeather(for: suggestion)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        if tableView == self.tableView {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
                let rowIndex = indexPath.row
                self?.userDefaultsManager.removeCity(rowIndex)
                self?.cityWeatherList.remove(at: rowIndex)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completion(true)
            }
            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

            return configuration
        } else {
            return nil
        }
    }
}

// MARK: - UITableViewDragDelegate

extension CityWeatherListViewController: UITableViewDragDelegate {
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}
 
// MARK: - UITableViewDropDelegate

extension CityWeatherListViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}
