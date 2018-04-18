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
        configureLabel(fontColor: UIColor.white)
        contentView.subviews.forEach { $0.layer.shadowEffect() }
        minTemperatureLabel.layer.shadowEffect()
        maxTemperatureLabel.layer.shadowEffect()
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: - Internal Methods

extension WeatherDetailCell {

    func setContents(_ weatherDetailHeaderViewModel: WeatherDetailHeaderViewModel?) {
        guard let vm = weatherDetailHeaderViewModel else { return }
        cityLabel.attributedText = NSMutableAttributedString(
            string: vm.city,
            attributes: StringAttribute.textWithBorder(fontSize: 31)
        )
        weatherLabel.attributedText = NSMutableAttributedString(
            string: vm.weather,
            attributes: StringAttribute.textWithBorder(fontSize: 20)
        )
        temperatureLabel.attributedText = NSMutableAttributedString(
            string: vm.temperature,
            attributes: StringAttribute.textWithBorder(fontSize: 50)
        )
        minTemperatureLabel.attributedText = NSMutableAttributedString(
            string: vm.minTemperature,
            attributes: StringAttribute.textWithBorder(fontSize: 17)
        )
        maxTemperatureLabel.attributedText = NSMutableAttributedString(
            string: vm.maxTemperature,
            attributes: StringAttribute.textWithBorder(fontSize: 17)
        )
    }

}

struct WeatherDetailHeaderViewModel {
    var city: String
    var weather: String
    var temperature: String
    var minTemperature: String
    var maxTemperature: String
}
