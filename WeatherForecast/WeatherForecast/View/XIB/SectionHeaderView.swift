//
//  SectionHeaderView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 25..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        makeTopCornerRound()
    }

    func makeTopCornerRound() {
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
