//
//  WeatherDetailViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var weatherDetailViewModel: WeatherDetailHeaderViewModel?
    var pageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension WeatherDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "WeatherDetailHeaderCell"
        let p = pageNumber ?? 0
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: id
            ) as? WeatherDetailHeaderCell else {
                return UITableViewCell()
        }

        cell.load(History.shared.weatherDetailViewModel(at: p))
        return cell
    }

}

extension WeatherDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
