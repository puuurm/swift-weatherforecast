//
//  Identifiable.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 6..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

protocol Identifiable: class {
    static var defaultIdentifier: String { get }
}

extension Identifiable {
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Identifiable {}
extension UICollectionViewCell: Identifiable {}
extension UIViewController: Identifiable {}
