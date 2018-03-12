//
//  Checker.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 12..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Checker {

    static func isNeedUpdate(
        before localName: String?,
        after newLocalName: String,
        object: Storable?) -> Bool {
        if let beforeLocalName = localName,
            beforeLocalName == newLocalName,
            let beforeObejct = object, !beforeObejct.isOutOfDate {
            return false
        }
        return true
    }

    static func isNeedUpdate(before object: Storable?) -> Bool {
        if let beforeObejct = object,
            !beforeObejct.isOutOfDate {
            return false
        }
        return true
    }

}
