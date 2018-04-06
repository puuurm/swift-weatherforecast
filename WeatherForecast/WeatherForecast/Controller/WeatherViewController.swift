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

    private var currentCell: WeatherTableViewCell?
    private var duration: Double = 0.8

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager(session: URLSession.shared)
        locationService = LocationService()
        locationService?.delegate = self

        initNotification()

        updateUserLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveCellsBackIfNeed(duration) {
            self.weatherTableView.reloadData()
        }
        closeCurrentCellIfNeed(duration)
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

    private func requestCurrentWeather(_ address: Address) {
        networkManager?.request(
            Request.cityName(address: address),
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
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {

        let cell: WeatherTableViewCell? = tableView.dequeueReusableCell(for: indexPath)
        let cellViewModel = History.shared.currentWeatherCell(at: indexPath)
        cell?.setContents(viewModel: cellViewModel)
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

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
        pushViewController(tableView, viewController: vc)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        guard let currentCell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else {
            return indexPath
        }
        self.currentCell = currentCell
        return indexPath
    }

}

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

// 출처 : https://github.com/Ramotion/preview-transition

extension WeatherViewController {

    func pushViewController(_ tableView: UITableView, viewController: WeatherDetailContainerViewController) {

        guard let currentCell = self.currentCell else { return }
        currentCell.openCell(self.view, duration: duration)
        moveCells(tableView, currentCell: currentCell, duration: duration)
        delay(duration) { [weak self] in
            self?.navigationController?.pushViewController(viewController, animated: false)
        }
    }

    func moveCells(_ tableView: UITableView, currentCell: WeatherTableViewCell, duration: Double) {
        guard let currentIndex = tableView.indexPath(for: currentCell) else {
            return
        }
        for case let cell as WeatherTableViewCell in tableView.visibleCells where cell != currentCell {
            cell.isMovedHidden = true
            let section = tableView.indexPath(for: cell)?.section ?? 0
            let direction = section < currentIndex.section ? WeatherTableViewCell.Direction.down : WeatherTableViewCell.Direction.up
            cell.animationMoveCell(direction, duration: duration, tableView: tableView, selectedIndexPath: currentIndex, close: false)
        }
    }

    func moveCellsBackIfNeed(_ duration: Double, completion: @escaping () -> Void) {

        guard let currentCell = self.currentCell,
            let currentIndex = weatherTableView.indexPath(for: currentCell) else {
                return
        }

        for case let cell as WeatherTableViewCell in weatherTableView.visibleCells where cell != currentCell {

            if cell.isMovedHidden == false { continue }

            if let indexPath = weatherTableView.indexPath(for: cell) {
                let direction = indexPath.section < currentIndex.section ? WeatherTableViewCell.Direction.up : WeatherTableViewCell.Direction.down
                cell.animationMoveCell(direction, duration: duration, tableView: weatherTableView, selectedIndexPath: currentIndex, close: true)
                cell.isMovedHidden = false
            }
        }
        delay(duration, closure: completion)
    }

    func closeCurrentCellIfNeed(_ duration: Double) {
        currentCell?.closeCell(duration, tableView: weatherTableView) { [weak self] in
            self?.currentCell = nil
        }
    }

    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
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
