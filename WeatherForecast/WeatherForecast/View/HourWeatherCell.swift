//
//  HourWeatherCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class HourWeatherCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
