//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailView: UIView {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func load(_ weatherDetailViewModel: WeatherDetailViewModel?) {
        guard let vm = weatherDetailViewModel else { return }
        cityLabel.text = vm.city
        weatherLabel.text = vm.weather
        temperatureLabel.text = vm.temperature
    }
}

struct WeatherDetailViewModel {
    var city: String
    var weather: String
    var temperature: String
}
