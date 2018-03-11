//
//  Forecast.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Forecast {
    private var time: TimeInterval
    var date: Date {
        return Date(timeIntervalSince1970: time)
    }
    private(set) var mainWeather: Weather
    private(set) var moreWeather: [WeatherDetail]
    private(set) var timeString: String
}

extension Forecast: Codable {
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case mainWeather = "main"
        case moreWeather = "weather"
        case timeString = "dt_txt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(TimeInterval.self, forKey: .time)
        mainWeather = try container.decode(Weather.self, forKey: .mainWeather)
        moreWeather = try container.decode([WeatherDetail].self, forKey: .moreWeather)
        timeString = try container.decode(String.self, forKey: .timeString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(time, forKey: .time)
        try container.encode(mainWeather, forKey: .mainWeather)
        try container.encode(moreWeather, forKey: .moreWeather)
        try container.encode(timeString, forKey: .timeString)
    }

}
