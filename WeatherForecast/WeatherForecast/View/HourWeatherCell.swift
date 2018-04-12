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
        configureLabel(fontColor: UIColor.white)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func configureLabel(fontColor: UIColor) {
        contentView.subviews.forEach { ($0 as? UILabel)?.textColor = fontColor }
    }

}

// MARK: - Internal methods

extension HourWeatherCell {

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
