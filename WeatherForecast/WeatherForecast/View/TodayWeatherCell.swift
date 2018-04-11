//
//  TodayWeatherCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

protocol TodayWeatherCellDataSource: class {
    func contentsData(cell: UITableViewCell) -> [Forecast]
    func fetchImage(cell: UITableViewCell, indexPath: IndexPath, completion: @escaping ((UIImage?) -> Void))
}

class TodayWeatherCell: ContentsCell {

    @IBOutlet weak var hourWeatherCollectionView: UICollectionView!

    weak var dataSource: TodayWeatherCellDataSource? = nil {
        willSet {
            hourWeatherCollectionView.dataSource = self
            hourWeatherCollectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.skyBlue()
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension TodayWeatherCell: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {

        return dataSource?.contentsData(cell: self).count ?? 0

    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

        let cell: HourWeatherCell? = collectionView.dequeueReusableCell(for: indexPath)
        let row = indexPath.row
        let current = dataSource?.contentsData(cell: self)[row]
        cell?.setContents(dataSource: self, index: row, content: current)
        dataSource?.fetchImage(cell: self, indexPath: indexPath) { image in
            DispatchQueue.main.async {
                cell?.setImage(image)
            }
        }
        return cell ?? UICollectionViewCell()

    }

}

extension TodayWeatherCell: LineChartDataSource {

    func baseData(lineChartView: LineChartView) -> [Float] {
        return dataSource?.contentsData(cell: self).map { $0.mainWeather.temperature.rounded() } ?? []
    }
}
