//
//  Storable.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 12..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

protocol Storable {
    var isOutOfDate: Bool { get }
    var cacheKeys: [String] { get }
}

protocol StorableImage {
    var cacheKey: String { get }
    var url: String { get }
}
