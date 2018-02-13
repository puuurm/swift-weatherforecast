//
//  Forecast.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    private(set) var time: Int
    private(set) var mainWeather: Weather
    private(set) var moreWeather: [WeatherDetail]
    private(set) var timeString: String

    enum CodingKeys: String, CodingKey {
        case time = "dt"
        case main
        case moreWeather = "weather"
        case timeString = "dt_txt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        mainWeather = try container.decode(Weather.self, forKey: .main)
        moreWeather = try container.decode([WeatherDetail].self, forKey: .moreWeather)
        timeString = try container.decode(String.self, forKey: .timeString)
    }
}
