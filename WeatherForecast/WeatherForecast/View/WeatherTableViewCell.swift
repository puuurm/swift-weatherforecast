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

    var isMovedHidden: Bool = false
    private var hasMarkerLabel: Bool = false

    private var closedXPosition: CGFloat = 0
    private var closedYPosition: CGFloat = 0
    private var closedHeight: CGFloat = 0
    private var closedWidth: CGFloat = 0

    private var damping: CGFloat = 0.78

    enum Direction {
        case up
        case down
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        makeCornerRound()
        backgroundColor = UIColor.skyBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setContents(viewModel: WeatherTableCellViewModel) {
        cityLabel.text = viewModel.cityString
        temperature.text = viewModel.temperatureString
        timeLabel.text = viewModel.timeString
        if viewModel.isUserLocation && !hasMarkerLabel {
            createMarker()
        }
    }

    private func createMarker() {
        let markerImageView = UIImageView(image: UIImage(named: "marker"))
        addSubview(markerImageView)
        markerImageView.contentMode = .scaleAspectFit
        markerImageView.translatesAutoresizingMaskIntoConstraints = false
        markerImageView.heightAnchor.constraint(equalTo: cityLabel.heightAnchor).isActive = true
        markerImageView.trailingAnchor.constraint(equalTo: cityLabel.leadingAnchor, constant: -5).isActive = true
        markerImageView.topAnchor.constraint(equalTo: cityLabel.topAnchor).isActive = true
        hasMarkerLabel = true
    }

    private func makeCornerRound() {
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner
        ]
    }
}

// 출처: https://github.com/Ramotion/preview-transition

extension WeatherTableViewCell {
    func openCell(_ baseView: UIView, duration: Double) {

        closedXPosition = center.x
        closedYPosition = center.y
        closedHeight = self.frame.height
        closedWidth = self.frame.width

        subviews.forEach { $0.isHidden = true }

        UIView.animate(withDuration: 0.5, animations: {
            self.superview?.frame.origin.x -= 10
            self.superview?.frame.size.width += 20
            self.frame.size.height = baseView.frame.size.height
        }, completion: nil)

        superview?.sendSubview(toBack: self)
        moveToCenter(duration, offset: 0)
    }

    func closeCell(_ duration: Double, tableView _: UITableView, completion: @escaping () -> Void) {

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.superview?.frame.origin.x += 10
                self.superview?.frame.size.width -= 20
                self.frame.size.height = self.closedHeight
                self.center = CGPoint(x: self.center.x, y: self.closedYPosition)
            }, completion: { [weak self] _ in
                self?.subviews.forEach { $0.isHidden = false }
                completion()
        })

    }

    func moveToCenter(_ duration: Double, offset: CGFloat) {

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.78,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions(),
            animations: { [weak self] in
                self?.frame.origin.y = offset
            }, completion: nil)

    }

    func animationMoveCell(
        _ direction: Direction,
        duration: Double,
        tableView: UITableView,
        selectedIndexPath: IndexPath,
        close: Bool) {

        let selfYPosition = close == false ? frame.origin.y : closedYPosition
        let selectedCellFrame = tableView.rectForRow(at: selectedIndexPath)
        var dy: CGFloat = 0
        if selfYPosition < selectedCellFrame.origin.y {
            dy = selectedCellFrame.origin.y - tableView.contentOffset.y
        } else {
            dy = tableView.frame.size.height - (selectedCellFrame.origin.y - tableView.contentOffset.y + selectedCellFrame.size.height)
        }
        dy = direction == .down ? dy * -1 : dy
        if close == false {
            closedYPosition = center.y
        } else {
            center.y = closedYPosition - dy
        }

        superview?.bringSubview(toFront: self)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions(),
            animations: { () -> Void in
                self.center.y += dy
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
