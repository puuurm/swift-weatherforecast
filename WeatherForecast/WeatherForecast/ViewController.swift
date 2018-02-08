//
//  ViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var weatherContainer: WeatherContainer?

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherContainer = WeatherContainer()
        weatherContainer?.fetchWeatherInfo(id: .korea)
    }


}

