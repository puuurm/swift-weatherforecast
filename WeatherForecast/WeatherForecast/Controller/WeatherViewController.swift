//
//  ViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

class WeatherViewController: UIViewController, Presentable {

    @IBOutlet weak var weatherTableView: UITableView!
    private var locationService: LocationService?
    private var networkManager: NetworkManager?
    private var selectedCell: FlexibleCell?
    private var flickerJSON: FlickerJSON? = nil {
        willSet {
            DispatchQueue.main.async { [weak self] in
                self?.weatherTableView.reloadData()
            }

        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func requestCurrentWeather(_ address: Address) {
        networkManager?.request(
            QueryItem.cityName(address: address),
            before: History.shared.userLocationForecast?.current,
            baseURL: .current,
            type: CurrentWeather.self
        ) { result -> Void in
                switch result {
                case let .success(weather):
                    History.shared.userLocationForecast = ForecastStore(address: address, current: weather)
                case let .failure(error): print(error)
                }
        }
    }

    private func requestFlickerImage() {
        networkManager?.request(
            QueryItem.photoSearch(tags: "landscape"),
            before: nil,
            baseURL: .photoList,
            type: FlickerJSON.self
        ) { [weak self] result -> Void in
            switch result {
            case let .success(flickerJSON):
                self?.flickerJSON = flickerJSON
            case let .failure(error): print(error)
            }
        }
    }
}

// MARK: - View Lifecycle

extension WeatherViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager(session: URLSession.shared)
        locationService = LocationService()
        locationService?.delegate = self
        initNotification()
        requestFlickerImage()
        updateUserLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveCellsBackIfNeed(weatherTableView, selectedCell: selectedCell)
        closeSelectedCellIfNeed(
            weatherTableView,
            selectedCell: selectedCell,
            duration: duration
        ) { [weak self] in
            self?.selectedCell = nil
        }
    }

}

// MARK: - Initializer

extension WeatherViewController {

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

}

// MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {

        let cell: WeatherTableViewCell? = tableView.dequeueReusableCell(for: indexPath)
        let cellViewModel = History.shared.currentWeatherCell(at: indexPath)
        cell?.setContents(viewModel: cellViewModel)
        networkManager?.request(flickerJSON?.photoObejct(at: indexPath.section)) { result in
            switch result {
            case let .success(photo):
                DispatchQueue.main.async {
                    cell?.setBackgroundImage(photo)
                }
            case let .failure(error): print(error)
            }
        }
        networkManager?.request(cellViewModel.weatherDetail, baseURL: .icon) { result in
            switch result {
            case let .success(icon):
                DispatchQueue.main.async {
                    cell?.weatherIconImageView.image = icon
                }
            case let .failure(error): print(error.localizedDescription)
            }
        }
        return cell ?? UITableViewCell()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return History.shared.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }

}

// MARK: - UITableViewDelegate

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            History.shared.delete(at: indexPath)
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherDetailVC: WeatherDetailContainerViewController? = storyboard?.viewController()
        guard let vc = weatherDetailVC else { return }
        vc.currentIndex = indexPath.section
        networkManager?.request(flickerJSON?.photoObejct(at: indexPath.section)) { result in
            switch result {
            case let .success(photo): vc.backgroundImage = photo
            case let .failure(error): print(error)
            }
        }
        pushViewController(tableView, viewController: vc)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        guard let selectedCell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else {
            return indexPath
        }
        self.selectedCell = selectedCell
        return indexPath
    }

    func pushViewController(_ tableView: UITableView, viewController: UIViewController) {

        guard let selectedCell = self.selectedCell else { return }
        selectedCell.openCell(tableView, duration: duration)
        moveCells(tableView, selectedCell: selectedCell, duration: duration)
        delay(duration) { [weak self] in
            self?.navigationController?.pushViewController(viewController, animated: false)
        }
    }

}

// MARK: - LocationServiceDelegate

extension WeatherViewController: LocationServiceDelegate {
    func updateLocation(_ placeMark: CLPlacemark?) {
        guard let location = placeMark?.location,
            let postalAddress = placeMark?.postalAddress else { return }
        let address = Address(location: location, postalAddress: postalAddress)
        guard Checker.isNeedUpdate(
            before: History.shared.userLocationForecast?.address,
            after: address,
            object: History.shared.userLocationForecast?.current
            ) else {
                return
        }
        requestCurrentWeather(address)
    }
}

// MARK: - AvailableFlexibleCells

extension WeatherViewController: AvailableFlexibleCells {
    var duration: Double {
        return 0.8
    }
}

// MARK: - Action

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
        let indexSet = IndexSet.init(integer: index)
        DispatchQueue.main.async { [weak self] in
            self?.weatherTableView.insertSections(indexSet, with: .automatic)
        }
    }

    @objc func updateCurrent(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexSet = IndexSet.init(integer: index)
        DispatchQueue.main.async { [weak self] in
            self?.weatherTableView.reloadSections(indexSet, with: .automatic)
        }
    }

    @objc func deleteWeather(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexSet = IndexSet.init(integer: index)
        DispatchQueue.main.async { [weak self] in
            self?.weatherTableView.deleteSections(indexSet, with: .automatic)
        }
    }
}
