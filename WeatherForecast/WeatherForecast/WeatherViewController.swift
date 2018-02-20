//
//  ViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!

    var dataManager = DataManager(session: URLSession.shared)

    var locationService: LocationService?
    var response = [Response]()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationService = LocationService()
        locationService?.delegate = self
        locationService?.searchCurrentLocation()
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func updateCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        dataManager.fetchForecastInfo(parameters: coordinate.query) { result -> Void in
            switch result {
            case let .success(r) :
                OperationQueue.main.addOperation {
                    if !self.response.isEmpty { self.response.removeFirst() }
                    self.response.insert(r, at: 0)
                    self.weatherTableView.reloadData()
                }
            case let .failure(error): print(error)
            }
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let cellId = "WeatherTableViewCell"
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellId,
            for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        let row = indexPath.row
        cell.cityLabel.text = response[row].city.name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension WeatherViewController: LocationServiceDelegate {
    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        updateCurrentLocation(coordinate)
    }
}
