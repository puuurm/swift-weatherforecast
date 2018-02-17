//
//  CitySearchController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import MapKit

class CitySearchController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var filterdCities: [MKLocalSearchCompletion] = [] {
        willSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
}

extension CitySearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "SearchTableViewCell"
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellId,
            for: indexPath
            ) as? SearchTableViewCell else { return UITableViewCell() }
        cell.cityLabel.text = filterdCities[indexPath.row].title
        return cell
    }
}

extension CitySearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension CitySearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarIsEmpty() {
            filterdCities.removeAll()
        }
        searchCompleter.queryFragment = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}

extension CitySearchController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if searchBarIsEmpty() {
            filterdCities.removeAll()
        } else {
            filterdCities = completer.results
        }
    }
}
