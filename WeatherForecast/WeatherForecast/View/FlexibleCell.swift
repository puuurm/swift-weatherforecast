//
//  FlexibleCell.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

enum Direction {
    case up
    case down
}

class FlexibleCell: UITableViewCell {

    var isMovedHidden: Bool = false
    private var flexibleImageView: UIImageView = UIImageView()
    private var closedFrame: CGRect = CGRect.zero
    private var closedHeight: CGFloat = 0
    private var closedY: CGFloat = 0
    private var damping: CGFloat = 0.78

    override func awakeFromNib() {
        super.awakeFromNib()
        flexibleImageView.frame = contentView.frame
        contentView.addSubview(flexibleImageView)
        flexibleImageView.tag = 10000
        flexibleImageView.translatesAutoresizingMaskIntoConstraints = false
        flexibleImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        flexibleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        flexibleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        flexibleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        contentView.sendSubview(toBack: flexibleImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setBackgroundImage(_ image: UIImage?) {
        guard let image = image else { return }
        flexibleImageView.image = image
    }

}

// MARK: - Reference https://github.com/Ramotion/preview-transition

extension FlexibleCell {

    func openCell(_ tableView: UITableView, duration: Double) {
        closedY = frame.origin.y
        closedHeight = frame.height
        contentView.subviews.forEach { if $0.tag != 10000 { $0.isHidden = true } }
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
                self?.contentView.subviews.forEach { $0.isHidden = false }
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
