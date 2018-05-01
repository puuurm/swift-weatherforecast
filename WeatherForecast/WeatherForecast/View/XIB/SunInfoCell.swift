//
//  SunInfoCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 13..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SunInfoCell: ContentsCell {

    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel(fontColor: UIColor.white)
        makeBottomCornerRound()
        contentView.subviews.forEach { $0.layer.shadowEffect() }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setContents(system: System?) {
        guard let system = system else { return }
        let sunriseTimeInterval = system.sunrise
        let sunsetTimeInterval = system.sunset
        sunriseLabel.text = Date(timeIntervalSince1970: sunriseTimeInterval).convertString(format: "HH:mm a")
        sunsetLabel.text = Date(timeIntervalSince1970: sunsetTimeInterval).convertString(format: "HH:mm a")
    }
}
