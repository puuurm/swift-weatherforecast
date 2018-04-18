//
//  CitySearchController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import MapKit

class CitySearchController: UIViewController, Presentable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var networkManager: NetworkManager?

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

    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }

    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    private func requestWeather(_ address: Address, completion: @escaping () -> Void) {
        networkManager?.request(
            QueryItem.coordinates(address: address),
            before: nil,
            baseURL: .current,
            type: CurrentWeather.self
        ) { result -> Void in
                switch result {
                case let .success(weather):
                    History.shared.append(ForecastStore(address: address, current: weather) )
                case let .failure(error): print(error)
                }
                completion()
        }
    }

    @IBAction func viewDidPanned(_ sender: AnyObject) {
        dismissKeyboard()
    }
}

// MARK: - View Lifecycle

extension CitySearchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsCancelButton = true
        networkManager = NetworkManager(session: URLSession.shared)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

}

// MARK: - UITableViewDataSource

extension CitySearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell? = tableView.dequeueReusableCell(for: indexPath)
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
        cell?.cityLabel.attributedText = mutableAttributedString
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension CitySearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCompleter = filterdCities[indexPath.row]
        let selectedCityName = selectedCompleter.title
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = selectedCityName
        MKLocalSearch(request: request).start { [weak self] (response, error) in
            if let error = error as? MKError {
                self?.presentErrorMessage(message: error.localizedDescription)
                return
            }
            guard let mapItem = response?.mapItems.first,
                let name = mapItem.name else {
                    return
            }
            let address = Address(name: name, placeMark: mapItem.placemark)
            self?.requestWeather(address) {
                DispatchQueue.main.async { [weak self] in
                    self?.dismissKeyboard()
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }

    }
}

// MARK: - UISearchBarDelegate

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

// MARK: - MKLocalSearchCompleterDelegate

extension CitySearchController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if searchBarIsEmpty() {
            filterdCities.removeAll()
        } else {
            filterdCities = completer.results.filter { $0.subtitle == "" }
        }
    }
}
