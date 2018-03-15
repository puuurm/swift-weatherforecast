//
//  TodayWeatherCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class TodayWeatherCell: ContentsCell {
    @IBOutlet weak var hourWeatherCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setDataSource (
        dataSource: UICollectionViewDataSource,
        at row: Int) {
        hourWeatherCollectionView.dataSource = dataSource
        hourWeatherCollectionView.tag = row
        hourWeatherCollectionView.backgroundColor = UIColor.clear
        hourWeatherCollectionView.reloadData()
    }
}
