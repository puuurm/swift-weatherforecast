//
//  HourWeatherCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class HourWeatherCell: UICollectionViewCell {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.skyBlue()
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        hourLabel.textColor = UIColor.white
        temperatureLabel.textColor = UIColor.white
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setContents(dataSource: LineChartDataSource, index: Int, content: Forecast?) {
        lineChartView.dataSource = dataSource
        lineChartView.cellIndex = index
        hourLabel.text = content?.date.convertString(format: "H시")
        temperatureLabel.text = content?.mainWeather.temperature.convertCelsius
    }

    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        self.weatherIconImageView.image = image
    }

}
