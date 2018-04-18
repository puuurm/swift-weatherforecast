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
        contentView.subviews.forEach { $0.layer.shadowEffect() }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func configureLabel(fontColor: UIColor) {
        hourLabel.textColor = fontColor
        temperatureLabel.textColor = fontColor
    }

}

// MARK: - Internal methods

extension HourWeatherCell {

    func setContents(dataSource: LineChartDataSource, index: Int, content: Forecast?) {
        guard let content = content else { return }
        lineChartView.dataSource = dataSource
        lineChartView.cellIndex = index
        hourLabel.attributedText = NSMutableAttributedString(string: content.date.convertString(format: "H시"), attributes: StringAttribute.textWithBorder(fontSize: 13))
        temperatureLabel.attributedText = NSMutableAttributedString(string: content.mainWeather.temperature.convertCelsius, attributes: StringAttribute.textWithBorder(fontSize: 17))
    }

    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        self.weatherIconImageView.image = image
    }

}
