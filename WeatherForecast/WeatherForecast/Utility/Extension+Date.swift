//
//  Extension+Date.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 2..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

extension Date {

    var isMoreThanAnHourSinceNow: Bool {
        return self.timeIntervalSinceNow < -3600
    }
}
