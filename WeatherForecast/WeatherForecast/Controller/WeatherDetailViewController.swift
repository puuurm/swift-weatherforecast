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
    var weatherDetailViewModel: WeatherDetailHeaderViewModel?
    var networkManager: NetworkManager?
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

    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.backgroundColor = UIColor.clear
        networkManager = NetworkManager(session: URLSession.shared)
        forecastTableView.register(type: SunInfoCell.self)
        forecastTableView.register(type: WeatherDetailCell.self)
        loadWeeklyForecast()
    }

    private func loadWeeklyForecast() {
        let localName = History.shared.localName(at: pageNumber)
        guard Checker.isNeedUpdate(before: weeklyForecast) else { return }
        networkManager?.request(
            localName,
            before: weeklyForecast,
            baseURL: .weekly,
            type: WeeklyForecast.self
        ) { [weak self] result -> Void in
                switch result {
                case let .success(weeklyForecast):
                    self?.weeklyForecast = weeklyForecast
                case let .failure(error): print(error.localizedDescription)
                }
        }
    }

    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

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
            cell?.load(History.shared.weatherDetailViewModel(at: pageNumber ?? 0))
            return cell ?? defaultCell
        case 1:
            let cell: TodayWeatherCell? = tableView.dequeueReusableCell(for: indexPath)
            return cell ?? defaultCell
        default:
            let cell: SunInfoCell? = tableView.dequeueReusableCell(for: indexPath)
            let sunriseTimeInterval = History.shared.forecastStores[pageNumber].current.system.sunrise
            let sunsetTimeInterval = History.shared.forecastStores[pageNumber].current.system.sunset
            cell?.sunriseLabel.text = Date(timeIntervalSince1970: sunriseTimeInterval).convertString(format: "HH:mm a")
            cell?.sunsetLabel.text = Date(timeIntervalSince1970: sunsetTimeInterval).convertString(format: "HH:mm a")
            return cell ?? defaultCell
        }
    }
}

extension WeatherDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 310
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
        let cell: SectionHeaderCell? = tableView.dequeueReusableCell()
        let section = Section(rawValue: section)
        cell?.dateLabel.text = section?.date
        return cell ?? UIView()
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let tableViewCell = cell as? TodayWeatherCell else { return }
            tableViewCell.setDataSource(dataSource: self, at: indexPath.row)
        default: break
        }

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
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

        let cell: HourWeatherCell? = collectionView.dequeueReusableCell(for: indexPath)
        let forecasts = weeklyForecast?.forecasts
        let row = indexPath.row
        let current = forecasts?[row]
        cell?.lineChartView.dataSource = self
        cell?.lineChartView.cellIndex = row
        cell?.hourLabel.text = current?.date.convertString(format: "H시")
        cell?.temperatureLabel.text = current?.mainWeather.temperature.convertCelsius
        if let weatherDetail = forecasts?[row].moreWeather.first {
            networkManager?.request(weatherDetail, baseURL: .icon) { result in
                switch result {
                case let .success(icon):
                    DispatchQueue.main.async {
                        cell?.weatherIconImageView.image = icon
                        cell?.weatherIconImageView.contentMode = .scaleAspectFit
                    }
                case let .failure(error): print(error.localizedDescription)
                }
            }
        }
        return cell ?? UICollectionViewCell()

    }
}

extension WeatherDetailViewController: LineChartDataSource {
    func baseData(lineChartView: LineChartView) -> [Float] {
        return History.shared.temperatures(at: pageNumber)
    }
}
