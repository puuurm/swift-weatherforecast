//
//  NetworkSpinner.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 11..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

struct NetworkSpinner {

    static func on() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    static func off() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

}
