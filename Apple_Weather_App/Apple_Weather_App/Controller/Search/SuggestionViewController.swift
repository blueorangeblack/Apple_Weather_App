//
//  SuggestionViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/09.
//

import MapKit
import UIKit

private let reuseID = "SuggestionCell"

class SuggestionViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var searchCompleter: MKLocalSearchCompleter?
    
    var completerResults: [MKLocalSearchCompletion]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(SuggestionCell.self, forCellReuseIdentifier: reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startProvidingCompletions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopProvidingCompletions()
    }
    
    // MARK: - Helpers
    
    private func startProvidingCompletions() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .address
        searchCompleter?.region = MKCoordinateRegion(MKMapRect.world)
    }
    
    private func stopProvidingCompletions() {
        searchCompleter = nil
        completerResults = nil
    }
}

// MARK: - UISearchResultsUpdating

extension SuggestionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              !text.isEmpty else { return }
        searchCompleter?.queryFragment = text
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension SuggestionViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}

// MARK: - UITableViewDataSource

extension SuggestionViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? SuggestionCell else { return UITableViewCell() }
        if let completerResult = completerResults?[indexPath.row] {
            cell.viewModel = SuggestionViewModel(completerResult: completerResult)
        }
        
        return cell
    }
}
