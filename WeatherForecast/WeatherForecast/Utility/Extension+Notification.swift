//
//  Extension+Notification.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 28..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

extension Notification.Name {

    static let DidUpdateTime = Notification.Name(rawValue: "DidUpdateTime")
    static let DidUpdateUserLocation = Notification.Name(rawValue: "DidUpdateUserLocation")
    static let DidUpdateCurrentWeather = Notification.Name(rawValue: "DidUpdateCurrentWeatehr")
    static let DidUpdateAllCurrentWeather = Notification.Name(rawValue: "DidUpdateAllCurrentWeather")
    static let DidUpdateWeeklyWeather = Notification.Name(rawValue: "DidUpdateWeeklyWeather")
    static let DidUpdateCurrentAndWeeklyOneLocation = Notification.Name(rawValue: "DidUpdateCurrentAndWeeklyOneLocation")

    static let DidInsertWeather = Notification.Name(rawValue: "DidInsertWeather")
    static let DidDeleteWeather = Notification.Name(rawValue: "DidDeleteWeather")

}
