//
//  Extension+Float.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

extension Float {
    var convertCelsius: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .halfEven
        let numberString = formatter.string(from: NSNumber(value: self)) ?? "0"
        return numberString.magnitudeIfNeeded.appending("º")
    }

}

extension String {
    var magnitudeIfNeeded: String {
        return self == "-0" ? "0" : self
    }
}
