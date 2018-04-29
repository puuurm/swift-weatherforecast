//
//  OptionSwitchCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 29..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class OptionSwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedSwitchView: SegmentedSwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setContents(cellModel: OptionSwitchCellModel) {
        titleLabel.text = cellModel.title
        segmentedSwitchView.dataSource = cellModel.items
    }

}

struct OptionSwitchCellModel {
    var title: String
    var items: [String]
}
