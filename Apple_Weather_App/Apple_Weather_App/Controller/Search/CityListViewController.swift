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
    
    private lazy var suggestionViewController: SuggestionViewController = {
        let vc = SuggestionViewController()
        vc.tableView.delegate = self
        return vc
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: suggestionViewController)
        sc.searchResultsUpdater = suggestionViewController
        sc.searchBar.placeholder = "도시 또는 공항 검색"
        sc.searchBar.setValue("취소", forKey: "cancelButtonText")
        sc.obscuresBackgroundDuringPresentation = true
        sc.searchBar.spellCheckingType = .no
        sc.searchBar.delegate = self
        return sc
    }()
    
    private lazy var places = [MKMapItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    // MARK: - Helpers
    
    private func configure() {
        tableView.register(CityListCell.self, forCellReuseIdentifier: reuseID)
        
        view.addSubview(suggestionViewController.view)
        suggestionViewController.view.frame = self.view.frame
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "날씨"
    }
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        searchRequest.region = MKCoordinateRegion(MKMapRect.world)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: { [weak self] response, error in
            guard error == nil else {
                self?.displaySearchError(error)
                return
            }
            
            let place = response?.mapItems.first
            print(place?.placemark.coordinate as Any)
            //print(self?.getPlaceString(place: place))

            self?.places.append(place ?? MKMapItem())
        })
    }
    
    private func displaySearchError(_ error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func getPlaceString(place: MKMapItem?) -> String {
        let locality = place?.placemark.locality
        let name = place?.name
        let subLocality = place?.placemark.subLocality
        print(locality)
        print(name)
        print(subLocality)
        print("==> \(locality ?? name ?? subLocality ?? "")")
        print("----------")
        return locality ?? name ?? subLocality ?? ""
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
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        let place = places[indexPath.row]
        let text = getPlaceString(place: place)
        cell.textLabel?.text = text
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CityListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == suggestionViewController.tableView,
           let suggestion = suggestionViewController.completerResults?[indexPath.row] {
            search(for: suggestion)
        }
    }
}
