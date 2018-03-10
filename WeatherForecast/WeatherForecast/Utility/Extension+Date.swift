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
        return self.timeIntervalSinceNow <= -3600
    }

    func convertString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
