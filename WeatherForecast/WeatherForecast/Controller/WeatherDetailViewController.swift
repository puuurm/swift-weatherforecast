//
//  WeatherDetailViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var headerView: WeatherDetailHeaderView!
    @IBOutlet weak var forecastTableView: UITableView!
    var weatherDetailViewModel: WeatherDetailHeaderViewModel?
    var dataManager: DataManager?
    var weeklyForecast: WeeklyForecast? {
        get {
            return History.shared.forecastStores[pageNumber].weekly
        }
        set {
            History.shared.add(at: pageNumber ?? 0, weeklyForecast: newValue)
            DispatchQueue.main.async { [weak self] in
                self?.forecastTableView.reloadData()
            }
        }
    }

    var pageNumber: Int!

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager(session: URLSession.shared)
        loadWeeklyForecast()
        loadHeaderViewContents()
        forecastTableView.backgroundColor = UIColor.clear
    }

    private func loadWeeklyForecast() {        let localName = History.shared.localName(at: pageNumber)
        guard Checker.isNeedUpdate(before: weeklyForecast) else { return }
        dataManager?.request(
            localName,
            before: weeklyForecast,
            baseURL: .weekly,
            type: WeeklyForecast.self) { [weak self] result -> Void in
                switch result {
                case let .success(weeklyForecast):
                    self?.weeklyForecast = weeklyForecast
                case let .failure(error): print(error.localizedDescription)
                }
        }
    }

    private func loadHeaderViewContents() {
        headerView.load(History.shared.weatherDetailViewModel(at: pageNumber ?? 0))
    }

    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension WeatherDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TodayWeatherCell"
            ) as? TodayWeatherCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension WeatherDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Header") as? SectionHeaderCell else {
            return UIView()
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TodayWeatherCell else { return }
        tableViewCell.setDataSource(dataSource: self, at: indexPath.row)
    }

}

extension WeatherDetailViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return weeklyForecast?.forecasts.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HourWeatherCell",
            for: indexPath) as? HourWeatherCell,
            let forecasts = weeklyForecast?.forecasts else { return UICollectionViewCell() }
        let row = indexPath.row
        let current = forecasts[row]
        cell.hourLabel.text = dateFormatter.string(from: current.date)
        cell.temperatureLabel.text = "\(current.mainWeather.temperature)º"
        let weatherDetail = forecasts[row].moreWeather.first!
        dataManager?.request(weatherDetail, baseURL: .icon) { result in
            switch result {
            case let .success(icon):
                DispatchQueue.main.async {
                    cell.weatherIconImageView.image = icon
                    cell.weatherIconImageView.contentMode = .scaleAspectFit
                }
            case let .failure(error): print(error.localizedDescription)
            }
        }
        return cell
    }
}
