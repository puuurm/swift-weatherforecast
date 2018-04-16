//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 13..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherTableViewCell: FlexibleCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var markerView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.skyBlue()
        cityLabel.textColor = UIColor.white
        temperature.textColor = UIColor.white
        timeLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setContents(viewModel: WeatherTableCellViewModel) {
        cityLabel.text = viewModel.cityString
        temperature.text = viewModel.temperatureString
        timeLabel.text = viewModel.timeString
        showMarkerIfNeeded(isUserLocation: viewModel.isUserLocation)
    }

    private func showMarkerIfNeeded(isUserLocation: Bool) {
        if isUserLocation {
            markerView.isHidden = false
        } else {
            markerView.isHidden = true
        }
    }
}

struct WeatherTableCellViewModel {
    var timeString: String
    var cityString: String
    var temperatureString: String
    var weatherDetail: WeatherDetail
    var isUserLocation: Bool
}
