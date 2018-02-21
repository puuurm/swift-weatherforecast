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

    var currentWeathers = [CurrentWeather]()
    var locationService: LocationService?

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func updateCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var params: Query = coordinate.query
        params["units"] = "metric"
        dataManager.fetchForecastInfo(
        baseURL: .currentWeather,
        parameters: params,
        type: CurrentWeather.self) { [weak self] result -> Void in
            switch result {
            case let .success(r) :
                self?.currentWeathers.append(r)
                OperationQueue.main.addOperation {
                    self?.weatherTableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        cell.cityLabel.text = currentWeathers[row].cityName
        cell.temperature.text = "\(currentWeathers[row].weather.temperature)°"
        cell.timeLabel.text = dateFormatter.string(from: Date())
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeathers.count
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
