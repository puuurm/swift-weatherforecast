//
//  AvailableDataSource.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 5. 1..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

protocol AvailableDataSource {
    var numberOfSections: Int { get }
    var numberOfRows: Int { get }
    func cellModel<T>(at indexPath: IndexPath) -> T?
}
