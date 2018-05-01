//
//  Extension+Float.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

extension String {

    var magnitudeIfNeeded: String {
        return self == "-0" ? "0" : self
    }

}
