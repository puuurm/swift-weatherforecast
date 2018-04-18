//
//  CurrentDetailCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 10..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class CurrentDetailCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        configureLabel(fontColor: UIColor.white)
        contentView.subviews.forEach { $0.layer.shadowEffect() }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setContents(viewModel: CurrentDetailCellViewModel) {
        guard let description = viewModel.description else { return }
        iconImageView.image = viewModel.image
        titleLabel.attributedText = NSMutableAttributedString(
            string: viewModel.title,
            attributes: StringAttribute.textWithBorder(fontSize: 11)
        )
        descriptionLabel.attributedText = NSMutableAttributedString(
            string: "\(description)",
            attributes: StringAttribute.textWithBorder(fontSize: 17)
        )
    }

    func configureLabel(fontColor: UIColor) {
        titleLabel.textColor =  fontColor
        descriptionLabel.textColor = fontColor
    }

}

struct CurrentDetailList {

    let current: CurrentWeather
    let icon = UIImage.Icons.Weather.self

    private var title: [String] {
        return ["pressure", "humidity", "wind", "clouds", "rain", "snow"]
    }

    private var description: [Any?] {
        return [ current.weather.pressure,
                 current.weather.humidity,
                 current.wind,
                 current.clouds,
                 current.rain,
                 current.snow ]
    }

    private var image: [UIImage] {
        return [ icon.Pressure, icon.Humidity, icon.Wind, icon.Clouds, icon.Rain, icon.Snow ]
    }

    func viewModel(at index: Int) -> CurrentDetailCellViewModel {
        return CurrentDetailCellViewModel(image: image[index], title: title[index], description: description[index])
    }

}

struct CurrentDetailCellViewModel {
    var image: UIImage
    var title: String
    var description: Any?
}
