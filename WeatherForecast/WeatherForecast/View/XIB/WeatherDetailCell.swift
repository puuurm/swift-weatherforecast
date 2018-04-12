//
//  WeatherDetailCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 14..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailCell: ContentsCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        configureLabel(fontColor: UIColor.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: - Internal Methods

extension WeatherDetailCell {

    func setContents(_ weatherDetailHeaderViewModel: WeatherDetailHeaderViewModel?) {
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
