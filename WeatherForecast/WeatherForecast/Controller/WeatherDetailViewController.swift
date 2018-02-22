//
//  WeatherDetailViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var weatherDetailView: WeatherDetailView!
    var weatherDetailViewModel: WeatherDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherDetailView.load(weatherDetailViewModel)
    }

}
