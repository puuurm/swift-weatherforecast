//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 13..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var markerView: UIImageView!

    var isMovedHidden: Bool = false

    private var closedFrame: CGRect = CGRect.zero
    private var closedHeight: CGFloat = 0
    private var closedY: CGFloat = 0


    private var damping: CGFloat = 0.78

    enum Direction {
        case up
        case down
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.skyBlue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setContents(viewModel: WeatherTableCellViewModel) {
        cityLabel.text = viewModel.cityString
        temperature.text = viewModel.temperatureString
        timeLabel.text = viewModel.timeString
        showMarkerIfNeeded(isUserLocation: viewModel.isUserLocation)
    }

    private func showMarkerIfNeeded(isUserLocation: Bool) {
        if isUserLocation {
            markerView.isHidden = false
        } else {
            markerView.isHidden = true
        }
    }
}

// 출처: https://github.com/Ramotion/preview-transition

extension WeatherTableViewCell {

    func openCell(_ tableView: UITableView, duration: Double) {
        closedY = frame.origin.y
        closedHeight = frame.height
        subviews.forEach { $0.isHidden = true }
        frame.origin.y = tableView.contentOffset.y
        frame.size.height = UIScreen.main.bounds.height
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.layoutIfNeeded() },
            completion: nil )
        superview?.sendSubview(toBack: self)
    }

    func closeCell(_ duration: Double, tableView: UITableView, completion: @escaping () -> Void) {
        frame.origin.y = closedY
        frame.size.height = closedHeight
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                self?.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.subviews.forEach { $0.isHidden = false }
                completion()
        })
    }

    func animationMoveCell(
        _ direction: Direction,
        duration: Double,
        tableView: UITableView,
        selectedIndexPath: IndexPath,
        close: Bool) {

        let selfYPosition = close == false ? frame.origin.y : closedFrame.origin.y
        let selectedCellFrame = tableView.rectForRow(at: selectedIndexPath)
        var dy: CGFloat = 0
        if selfYPosition < selectedCellFrame.origin.y {
            dy = selectedCellFrame.origin.y - tableView.contentOffset.y
        } else {
            dy = tableView.frame.size.height - (selectedCellFrame.origin.y - tableView.contentOffset.y + selectedCellFrame.size.height)
        }
        dy = direction == .down ? dy * -1 : dy
        if close == false {
            closedFrame.origin.y = frame.origin.y
        } else {
            frame.origin.y = closedFrame.origin.y - dy
        }

        superview?.bringSubview(toFront: self)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                self?.frame.origin.y += dy
        }, completion: nil)

    }
}

struct WeatherTableCellViewModel {
    var timeString: String
    var cityString: String
    var temperatureString: String
    var weatherDetail: WeatherDetail
    var isUserLocation: Bool
}
