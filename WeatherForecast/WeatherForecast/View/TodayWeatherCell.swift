//
//  TodayWeatherCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class TodayWeatherCell: UITableViewCell {
    @IBOutlet weak var hourWeatherCollectionView: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
