//
//  CurrentDetailBoxCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 10..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class CurrentDetailBoxCell: ContentsCell {

    @IBOutlet weak var currentDetailCollectionView: UICollectionView!

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
        currentDetailCollectionView.dataSource = dataSource
        currentDetailCollectionView.tag = row
        currentDetailCollectionView.backgroundColor = UIColor.clear
        currentDetailCollectionView.reloadData()
    }

}
