//
//  Extension+Date.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 2..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

extension Date {

    func isMoreThanSinceNow(hour: Double) -> Bool {
        print(self.convertString(format: "yyyy-MM-dd HH:mm:ssZZZZZ"))
        return self.timeIntervalSinceNow < ((-1) * 3600 * hour)
    }

    func convertString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
}

extension Float {

    var convertCelsius: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .halfEven
        let numberString = formatter.string(from: NSNumber(value: self)) ?? "0"
        return numberString.appending("º")
    }
}
