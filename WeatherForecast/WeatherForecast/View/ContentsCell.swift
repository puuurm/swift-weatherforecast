//
//  ContentsCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 15..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class ContentsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func makeBottomCornerRound() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func makeTopCornerRound() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func configureLabel(fontColor: UIColor) {
        contentView.subviews.forEach { ($0 as? UILabel)?.textColor = fontColor }
    }

}
