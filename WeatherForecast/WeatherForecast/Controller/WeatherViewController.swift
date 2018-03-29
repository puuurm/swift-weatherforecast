//
//  ViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, Presentable {

    @IBOutlet weak var weatherTableView: UITableView!

    var locationService: LocationService?
    var networkManager: NetworkManager?
    lazy var clock = Clock()

    override func viewDidLoad() {
        super.viewDidLoad()
        initNotification()
        clock.start()
        networkManager = NetworkManager(session: URLSession.shared)
        locationService = LocationService()
        locationService?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func initNotification() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateTime),
            name: .DidUpdateTime,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateUserLocation),
            name: .DidUpdateUserLocation,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.insertWeather(notification:)),
            name: .DidInsertWeather,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateCurrent(notification:)),
            name: .DidUpdateCurrentWeather,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.deleteWeather(notification:)),
            name: .DidDeleteWeather,
            object: nil
        )
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func requestCurrentWeather(_ localName: String) {
        networkManager?.request(
            localName,
            before: History.shared.userLocationForecast?.current,
            baseURL: .current,
            type: CurrentWeather.self) { result -> Void in
                switch result {
                case let .success(weather):
                    History.shared.userLocationForecast = ForecastStore(localName: localName, current: weather)
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
            for: indexPath
            ) as? WeatherTableViewCell else {
                return UITableViewCell()
        }
        let cellViewModel = History.shared.currentWeatherCell(at: indexPath)
        cell.cityLabel.text = cellViewModel.cityString
        cell.temperature.text = cellViewModel.temperatureString
        cell.timeLabel.text = cellViewModel.timeString
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return History.shared.count
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
            withIdentifier: "WeatherDetailContainerViewController"
            ) as? WeatherDetailContainerViewController else {
            return
        }
        weatherDetailVC.currentIndex = indexPath.row
        present(weatherDetailVC, animated: true, completion: nil)
    }
}

extension WeatherViewController: LocationServiceDelegate {
    func updateLocation(_ placeMark: CLPlacemark?) {
        guard let localName = placeMark?.locality,
            Checker.isNeedUpdate(
                before: History.shared.userLocationForecast?.localName,
                after: localName,
                object: History.shared.userLocationForecast?.current
            ) else {
                return
        }
        requestCurrentWeather(localName)
    }
}

// MARK: - Events
extension WeatherViewController {

    @objc func updateTime() {
        DispatchQueue.main.async { [weak self] in
            self?.weatherTableView.reloadData()
        }
    }

    @objc func updateUserLocation() {
        locationService?.startReceivingLocationChanges()
    }

    @objc func insertWeather(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexPath = IndexPath.init(row: index, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.weatherTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    @objc func updateCurrent(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexPath = IndexPath.init(row: index, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.weatherTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    @objc func deleteWeather(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexPath = IndexPath.init(row: index, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.weatherTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
