//
//  AvailableFlexibleCells.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

// MARK: - Reference https://github.com/Ramotion/preview-transition

protocol AvailableFlexibleCells {
    typealias Handler = (() -> Void)
    var duration: Double { get }
    func moveCells(_ tableView: UITableView, selectedCell: FlexibleCell, duration: Double)
    func moveCellsBackIfNeed(_ tableView: UITableView, selectedCell: FlexibleCell?)
    func closeSelectedCellIfNeed(
        _ tableView: UITableView,
        selectedCell: FlexibleCell?,
        duration: Double,
        completion: @escaping Handler
    )
    func delay(_ delay: Double, completion: @escaping Handler)
}

extension AvailableFlexibleCells {

    func moveCells(_ tableView: UITableView, selectedCell: FlexibleCell, duration: Double) {
        guard let currentIndex = tableView.indexPath(for: selectedCell) else { return }
        for case let cell as FlexibleCell in tableView.visibleCells where cell != selectedCell {
            cell.isMovedHidden = true
            let section = tableView.indexPath(for: cell)?.section ?? 0
            let direction = section < currentIndex.section ? Direction.down : Direction.up
            cell.animationMoveCell(
                direction,
                duration: duration,
                tableView: tableView,
                selectedIndexPath: currentIndex,
                close: false
            )
        }
    }

    func moveCellsBackIfNeed(_ tableView: UITableView, selectedCell: FlexibleCell?) {

        guard let selectedCell = selectedCell,
            let currentIndex = tableView.indexPath(for: selectedCell) else {
                return
        }

        for case let cell as FlexibleCell in tableView.visibleCells where cell != selectedCell {

            if cell.isMovedHidden == false { continue }

            if let indexPath = tableView.indexPath(for: cell) {
                let direction = indexPath.section < currentIndex.section ? Direction.up : Direction.down
                cell.animationMoveCell(
                    direction,
                    duration: duration,
                    tableView: tableView,
                    selectedIndexPath: currentIndex,
                    close: true
                )
                cell.isMovedHidden = false
            }
        }
    }

    func closeSelectedCellIfNeed(
        _ tableView: UITableView,
        selectedCell: FlexibleCell?,
        duration: Double,
        completion: @escaping () -> Void
        ) {
        selectedCell?.closeCell(duration, tableView: tableView, completion: completion)
    }

    func delay(_ delay: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: completion
        )
    }
}
