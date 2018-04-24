//
//  SectionHeaderCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SectionHeaderCell: ContentsCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        makeTopCornerRound()
        configureLabel(fontColor: UIColor.white)
        titleLabel.layer.shadowEffect()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setContents(title: String) {
        titleLabel.attributedText = NSMutableAttributedString(
            string: title,
            attributes: StringAttribute.textWithBorder(fontSize: 17)
        )
    }

}

