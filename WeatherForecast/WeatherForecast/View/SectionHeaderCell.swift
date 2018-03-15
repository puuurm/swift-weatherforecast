//
//  SectionHeaderCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SectionHeaderCell: UITableViewCell {
    @IBOutlet weak var dateLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        makeTopCornerRound()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func makeTopCornerRound() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

}
