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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
