//
//  WeatherDetailViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var forecastTableView: UITableView!

    var backgroundImage: UIImage?
    var networkManager: NetworkManager?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(self.handleRefresh(_:)),
            for: UIControlEvents.valueChanged
        )
        return refreshControl
    }()

    var pageNumber: Int!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - View Lifecycle
extension WeatherDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: .DidUpdateCurrentWeather,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateCurrent()
        }
        NotificationCenter.default.addObserver(
            forName: .DidUpdateWeeklyWeather,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateWeekly()
        }
        NotificationCenter.default.addObserver(
            forName: .DidUpdateCurrentAndWeeklyOneLocation,
            object: nil,
            queue: .current
        ) { [weak self] _ in
            self?.updateCurrentAndWeekly()
        }
        networkManager = NetworkManager(session: URLSession.shared)
        forecastTableView.addSubview(refreshControl)
        addBackgroundImageView()
        initTableViewAttributes()
        registerXib()
        requestWeeklyForecast()
    }
}

// MAKR: - Initializer

extension WeatherDetailViewController {

    private func addBackgroundImageView() {
        let backgroundImageView = makeBackgroundImageView()
        view.insertSubview(backgroundImageView, at: 0)
    }

    private func makeBackgroundImageView() -> UIImageView {
        let backgroundImageView = UIImageView()
        backgroundImageView.frame = view.frame
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleToFill
        return backgroundImageView
    }

    private func initTableViewAttributes() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.7
        forecastTableView.layer.add(animation, forKey: "animation")
        forecastTableView.backgroundColor = UIColor.clear
    }

    func registerXib() {
        forecastTableView.registerCell(type: SunInfoCell.self)
        forecastTableView.registerCell(type: WeatherDetailCell.self)
        forecastTableView.registerView(type: SectionHeaderView.self)
    }
}

// MAKR: - UITableViewDataSource

extension WeatherDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell: WeatherDetailCell? = tableView.dequeueReusableCell(for: indexPath)
            cell?.setContents(History.shared.weatherDetailViewModel(at: pageNumber))
            return cell ?? defaultCell
        case 1:
            let cell: TodayWeatherCell? = tableView.dequeueReusableCell(for: indexPath)
            return cell ?? defaultCell
        case 2:
            let cell: CurrentDetailBoxCell? = tableView.dequeueReusableCell(for: indexPath)
            return cell ?? defaultCell
        default:
            let cell: SunInfoCell? = tableView.dequeueReusableCell(for: indexPath)
            let system = History.shared.current(at: pageNumber)?.system
            cell?.setContents(system: system)
            return cell ?? defaultCell
        }
    }
}

// MARK: - UITableViewDelegate

extension WeatherDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 310
        case 2:
            let count: Int = History.shared.currentDetailCount(at: pageNumber)
            return CGFloat(100 * (count/2 + count%2))
        default: return 200
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        default: return 60
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SectionHeaderView? = tableView.dequeueReusableView()
        let section = Section(rawValue: section)
        header?.titleLabel.text = section?.date
        return header ?? UIView()
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let tableViewCell = cell as? TodayWeatherCell else { return }
            tableViewCell.setDataSource(dataSource: self, at: indexPath.section)
        case 2:
            guard let tableViewCell = cell as? CurrentDetailBoxCell else { return }
            tableViewCell.setDataSource(dataSource: self, at: indexPath.section)
        default: break
        }

    }

}

// MARK: - UICollectionViewDataSource

extension WeatherDetailViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        if collectionView.tag == 1 {
            return History.shared.weekly(at: pageNumber)?.forecasts.count ?? 0
        } else {
            return History.shared.currentDetailCount(at: pageNumber)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

        if collectionView.tag == 1 {
            return setHourWeatherCell(collectionView: collectionView, indexPath: indexPath)
        }

        if collectionView.tag == 2 {
            let cell: CurrentDetailCell? = collectionView.dequeueReusableCell(for: indexPath)
            let current = History.shared.currentDetailCell(at: pageNumber, row: indexPath.row)
            cell?.setContents(viewModel: current)
            return cell ?? UICollectionViewCell()
        }

        return UICollectionViewCell()
    }

}

// MARK: - LineChartDataSource

extension WeatherDetailViewController: LineChartDataSource {

    func baseData(lineChartView: LineChartView) -> [Float] {
        return History.shared.temperatures(at: pageNumber)
    }

}

// MARK: - Networking

extension WeatherDetailViewController {

    private func requestWeeklyForecast() {
        guard let address = History.shared.address(at: pageNumber ?? 0) else {return}
        if let weekly = History.shared.weekly(at: pageNumber),
            !Checker.isNeedUpdate(before: weekly) {
                return
        }
        networkManager?.request(
            QueryItem.coordinates(address: address),
            before: History.shared.weekly(at: pageNumber),
            baseURL: .weekly,
            type: WeeklyForecast.self
        ) { [weak self] result -> Void in
            guard let `self` = self else { return }
            switch result {
            case let .success(weeklyForecast):
                History.shared.updateWeeklyWeather(at: self.pageNumber, weekly: weeklyForecast)
            case let .failure(error): print(error.localizedDescription)
            }
        }
    }

    private func requestCurrentWeather() {
        guard let address = History.shared.address(at: pageNumber ?? 0),
            Checker.isNeedUpdate(
            before: History.shared.current(at: pageNumber)
            ) else {
                return
        }
        networkManager?.request(
            QueryItem.coordinates(address: address),
            before: History.shared.current(at: pageNumber),
            baseURL: .current,
            type: CurrentWeather.self
        ) { [weak self] result -> Void in
            guard let `self` = self else { return }
            switch result {
            case let .success(weather):
                History.shared.updateCurrentWeather(
                    at: self.pageNumber,
                    forecastStore: ForecastStore(address: address, current: weather)
                )
            case let .failure(error): print(error)
            }
        }
    }

    private func setHourWeatherCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HourWeatherCell? = collectionView.dequeueReusableCell(for: indexPath)
        let row = indexPath.row
        let forecast = History.shared.weekly(at: pageNumber)?.forecasts[row]
        cell?.setContents(dataSource: self, index: row, content: forecast)
        if let weatherDetail = forecast?.moreWeather.first {
            networkManager?.request(weatherDetail, imageExtension: .png) { result in
                switch result {
                case let .success(icon):
                    DispatchQueue.main.async {
                        cell?.setImage(icon)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        return cell ?? UICollectionViewCell()

    }

}

// MARK: - Action
extension WeatherDetailViewController {

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateCurrentAndWeekly()
        refreshControl.endRefreshing()
    }

    func updateCurrentAndWeekly() {
        requestWeeklyForecast()
        requestCurrentWeather()
    }

    func updateCurrent() {
        let indexSet = IndexSet([0, 2, 3])
        forecastTableView.reloadSections(indexSet, with: .none)
    }

    func updateWeekly() {
        let indexSet = IndexSet.init(integer: 1)
        forecastTableView.reloadSections(indexSet, with: .none)
    }

}
