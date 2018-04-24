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
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(self.handleRefresh(_:)),
            for: UIControlEvents.valueChanged
        )
        return refreshControl
    }()

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - View Lifecycle

extension WeatherViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager(session: URLSession.shared)
        weatherTableView.addSubview(refreshControl)
        locationService = LocationService()
        locationService?.delegate = self
        initNotification()
        requestFlickerJSON()
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
            forName: .DidUpdateTime,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTime()
        }

        NotificationCenter.default.addObserver(
            forName: .DidUpdateUserLocation,
            object: nil,
            queue: .current
        ) { [weak self] _ in
            self?.updateUserLocation()
        }

        NotificationCenter.default.addObserver(
            forName: .DidInsertWeather,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.insertWeather(notification: notification)
        }

        NotificationCenter.default.addObserver(
            forName: .DidUpdateCurrentWeather,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.updateCurrent(notification: notification)
        }

        NotificationCenter.default.addObserver(
            forName: .DidDeleteWeather,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.deleteWeather(notification: notification)
        }

        NotificationCenter.default.addObserver(
            forName: .DidUpdateAllCurrentWeather,
            object: nil,
            queue: .current
        ) { [weak self]_ in
            self?.updateAllCurrentWeather()
        }
    }

}

// MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {

        let cell: WeatherTableViewCell? = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = History.shared.currentWeatherCell(at: indexPath)
        cell?.setContents(viewModel: viewModel)
        requestFlickerImage(indexPath: indexPath, cell: cell)
        requestIcon(viewModel: viewModel, cell: cell)
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
        networkManager?.request(
            flickerJSON?.photo(at: indexPath.section),
            imageExtension: .jpg
        ) { result in
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
        let userLocationIndex: Int = 0
        guard let location = placeMark?.location,
            let postalAddress = placeMark?.postalAddress else { return }
        let address = Address(location: location, postalAddress: postalAddress)
        requestCurrentWeather(userLocationIndex, address: address)
    }
}

// MARK: - AvailableFlexibleCells

extension WeatherViewController: AvailableFlexibleCells {
    var duration: Double {
        return 0.8
    }
}

// MARK: - Networking

extension WeatherViewController {

    private func requestCurrentWeather(_ index: Int, address: Address) {
        guard Checker.isNeedUpdate(
            before: History.shared.forecastStores[index].address,
            after: address,
            object: History.shared.forecastStores[index].current
            ) else {
                return
        }
        networkManager?.request(
            QueryItem.coordinates(address: History.shared.address(at: index)),
            before: History.shared.forecastStores[index].current,
            baseURL: .current,
            type: CurrentWeather.self
        ) { result -> Void in
            switch result {
            case let .success(weather):
                History.shared.updateCurrentWeather(
                    at: index,
                    forecastStore: ForecastStore(address: address, current: weather)
                )
            case let .failure(error): print(error)
            }
        }
    }

    private func requestFlickerJSON() {
        networkManager?.request(
            QueryItem.photoSearch(tags: "sky,building"),
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

    private func requestFlickerImage(indexPath: IndexPath, cell: WeatherTableViewCell?) {
        networkManager?.request(
            flickerJSON?.photo(at: indexPath.section),
            imageExtension: .jpg
        ) { result in
            switch result {
            case let .success(photo):
                DispatchQueue.main.async {
                    cell?.setBackgroundImage(photo)
                }
            case let .failure(error): print(error)
            }
        }
    }

    private func requestIcon(viewModel: WeatherTableCellViewModel, cell: WeatherTableViewCell?) {
        networkManager?.request(
            viewModel.weatherDetail,
            imageExtension: .png
        ) { result in
            switch result {
            case let .success(icon):
                DispatchQueue.main.async {
                    cell?.weatherIconImageView.image = icon
                }
            case let .failure(error): print(error.localizedDescription)
            }
        }
    }

}

// MARK: - Action

extension WeatherViewController {

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateAllCurrentWeather()
        refreshControl.endRefreshing()
    }

    func updateAllCurrentWeather() {
        for index in 0..<History.shared.count {
            requestCurrentWeather(index, address: History.shared.address(at: index))
        }
    }

    func updateTime() {
        weatherTableView.reloadData()
    }

    func updateUserLocation() {
        locationService?.startReceivingLocationChanges()
    }

    func insertWeather(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexSet = IndexSet.init(integer: index)
        weatherTableView.insertSections(indexSet, with: .automatic)
    }

    func updateCurrent(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexSet = IndexSet.init(integer: index)
        weatherTableView.reloadSections(indexSet, with: .automatic)
    }

    func deleteWeather(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
                return
        }
        let indexSet = IndexSet.init(integer: index)
        weatherTableView.deleteSections(indexSet, with: .automatic)
    }
}
