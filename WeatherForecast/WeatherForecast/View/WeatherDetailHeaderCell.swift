//
//  WeatherDetailHeaderCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailHeaderCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func load(_ weatherDetailHeaderViewModel: WeatherDetailHeaderViewModel?) {
        guard let vm = weatherDetailHeaderViewModel else { return }
        cityLabel.text = vm.city
        weatherLabel.text = vm.weather
        temperatureLabel.text = vm.temperature
        minTemperatureLabel.text = vm.minTemperature
        maxTemperatureLabel.text = vm.maxTemperature
    }
}

struct WeatherDetailHeaderViewModel {
    var city: String
    var weather: String
    var temperature: String
    var minTemperature: String
    var maxTemperature: String
}
