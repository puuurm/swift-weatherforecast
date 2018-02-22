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

    let indexOfCurrentLocationWeather: Int = 0
    var locationService: LocationService?

    override func viewDidLoad() {
        super.viewDidLoad()
        initHistoryClosure()
        locationService = LocationService()
        locationService?.delegate = self
        locationService?.searchCurrentLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func initHistoryClosure() {
        History.shared.reloadWeatherViewCell = { [weak self] in
            self?.weatherTableView.reloadData()
        }

        History.shared.onNetworkStatus = {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        History.shared.offNetworkStatus = {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        let cellViewModel = History.shared.currentWeatherCell(at: indexPath)
        cell.cityLabel.text = cellViewModel.cityString
        cell.temperature.text = cellViewModel.temperatureString
        cell.timeLabel.text = cellViewModel.timeString
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return History.shared.numberOfCell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }

}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath ) {
        if editingStyle == .delete {
            History.shared.delete(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weatherDetailVC = storyboard?.instantiateViewController(
            withIdentifier: "WeatherDetailViewController"
            ) as? WeatherDetailViewController else {
            return
        }
        weatherDetailVC.weatherDetailViewModel = History.shared.weatherDetailViewModel(as: indexPath)
        navigationController?.pushViewController(weatherDetailVC, animated: true)
    }
}

extension WeatherViewController: LocationServiceDelegate {
    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        History.shared.requestWeather(coordinate)
    }
}
