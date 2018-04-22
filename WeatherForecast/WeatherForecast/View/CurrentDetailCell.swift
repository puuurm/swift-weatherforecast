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
        iconImageView.image = viewModel.image
        titleLabel.attributedText = NSMutableAttributedString(
            string: viewModel.title,
            attributes: StringAttribute.textWithBorder(fontSize: 11)
        )
        descriptionLabel.attributedText = NSMutableAttributedString(
            string: viewModel.description,
            attributes: StringAttribute.textWithBorder(fontSize: 17)
        )
    }

    func configureLabel(fontColor: UIColor) {
        titleLabel.textColor =  fontColor
        descriptionLabel.textColor = fontColor
    }

}

struct CurrentDetailList {

    private let current: CurrentWeather
    private var detailWeathers: [AvailableDetailWeather] = []
    var count: Int {
        return detailWeathers.count
    }

    init(current: CurrentWeather) {
        self.current = current
        createDetailWeathers()
    }

    mutating func createDetailWeathers() {
        let details: [AvailableDetailWeather?] = [ current.weather.pressure,
                                                   current.weather.humidity,
                                                   current.wind,
                                                   current.clouds,
                                                   current.rain,
                                                   current.snow ]
        detailWeathers = details.flatMap { $0 }
    }

    func currentDetailCellViewModel(at index: Int) -> CurrentDetailCellViewModel {
        let current = detailWeathers[index]
        return CurrentDetailCellViewModel(
            image: current.image,
            title: current.title,
            description: current.contents
        )
    }
}

struct CurrentDetailCellViewModel {
    var image: UIImage
    var title: String
    var description: String
}
