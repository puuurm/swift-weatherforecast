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
        completer.filterType = .locationsOnly
        return completer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsCancelButton = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }

    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    @IBAction func viewDidPanned(_ sender: AnyObject) {
        dismissKeyboard()
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
        let city = filterdCities[indexPath.row]
        let mutableAttributedString = NSMutableAttributedString(
            string: city.title,
            attributes: [NSAttributedStringKey.font: UIFont.georgia(ofSize: 18)]
        )
        city.titleHighlightRanges.forEach {
            mutableAttributedString.addAttribute(
                .backgroundColor,
                value: UIColor.yellow,
                range: $0.rangeValue
            )
        }
        cell.cityLabel.attributedText = mutableAttributedString
        return cell
    }
}

extension CitySearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCityName = filterdCities[indexPath.row]
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = selectedCityName.title
        MKLocalSearch(request: request).start { [weak self] (response, error) in
            if let error = error { print(error.localizedDescription) }
            guard let mapItem = response?.mapItems.first else { return }
            let coordinate = mapItem.placemark.coordinate
            //History.shared.requestWeather(coordinate)
            self?.dismissKeyboard()
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

extension CitySearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarIsEmpty() {
            filterdCities.removeAll()
        } else {
            searchCompleter.queryFragment = searchText
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
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
