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
    var pageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderViewContents()
    }

    private func loadHeaderViewContents() {
        guard let page = pageNumber else {
            return
        }
        headerView.load(History.shared.weatherDetailViewModel(at: page))
    }
}
