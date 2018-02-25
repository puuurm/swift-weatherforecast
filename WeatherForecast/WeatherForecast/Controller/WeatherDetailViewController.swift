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
    var weatherDetailViewModel: WeatherDetailHeaderViewModel?
    var weeklyForecast: WeeklyForecast?
    var dataManager: DataManager?

    var pageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager(session: URLSession.shared)
        loadWeeklyForecaste()
        loadHeaderViewContents()
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
}
