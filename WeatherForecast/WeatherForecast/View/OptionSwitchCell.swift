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

    func setContents(cellModel: OptionSwitchCellModel?, delegate: SegmentedSwitchDelegate) {
        guard let cellModel = cellModel else { return }
        titleLabel.text = cellModel.title
        segmentedSwitchView.dataSource = cellModel.dataSource
        segmentedSwitchView.delegate = delegate
    }

    func updateValue(_ value: String) {
        segmentedSwitchView.setValue(value)
    }

}

struct OptionSwitchCellModel {
    var title: String
    var dataSource: [String]
}
