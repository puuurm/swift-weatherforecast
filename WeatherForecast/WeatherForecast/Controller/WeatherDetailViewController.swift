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
    var weeklyForecast: WeeklyForecast?
    var dataManager: DataManager?

    var pageNumber: Int?

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
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }
}

extension WeatherDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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

}
