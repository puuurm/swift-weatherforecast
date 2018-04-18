//
//  Extension+UIView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 6..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: Identifiable>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultIdentifier, for: indexPath) as? T else {
            return nil
        }
        return cell
    }

    func dequeueReusableCell<T: Identifiable>() -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultIdentifier) as? T else {
            return nil
        }
        return cell
    }

    func register<T: Identifiable>(type: T.Type) {
        let bundle = Bundle(for: type)
        let uiNib = UINib(nibName: T.defaultIdentifier, bundle: bundle)
        register(uiNib, forCellReuseIdentifier: T.defaultIdentifier)
    }
}

extension UICollectionView {

    func dequeueReusableCell<T: Identifiable>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultIdentifier, for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}

extension UIStoryboard {

    func viewController<T: Identifiable>() -> T? {
        guard let VC = instantiateViewController(withIdentifier: T.defaultIdentifier) as? T else {
            return nil
        }
        return VC
    }
}

extension CALayer {
    func shadowEffect() {
        shadowColor = UIColor.black.cgColor
        shadowRadius = 3.0
        shadowOpacity = 1
        shadowOffset = CGSize(width: 4, height: 4)
        masksToBounds = false
    }
}
