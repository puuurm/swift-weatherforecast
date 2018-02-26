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
    var weeklyForecast: WeeklyForecast? = nil {
        didSet {
            forecastTableView.reloadData()
        }
    }
    var dataManager: DataManager?

    var pageNumber: Int?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager(session: URLSession.shared)
        loadWeeklyForecaste()
        loadHeaderViewContents()
        forecastTableView.backgroundColor = UIColor.clear
    }

    func loadWeeklyForecaste() {
        let coord = History.shared.coordinate(at: pageNumber ?? 0)
        var params: Query = coord.query
        params["units"] = "metric"
        dataManager?.fetchForecastInfo(
            baseURL: .forecast,
            parameters: params,
            type: WeeklyForecast.self) { [weak self] forecast -> Void in
                switch forecast {
                case let .success(result) :
                    OperationQueue.main.addOperation {
                        self?.weeklyForecast = result
                    }
                case let .failure(error): print(error)
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

    func tableView(_ tableView: UITableView,
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
        cell.hourLabel.text = dateFormatter.string(from: current.time)
        cell.temperatureLabel.text = "\(current.mainWeather.temperature)º"
        return cell
    }
}
