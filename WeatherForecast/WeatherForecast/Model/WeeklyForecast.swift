//
//  WeeklyForecast.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct WeeklyForecast {
    private(set) var code: String
    private(set) var message: Float
    private(set) var cnt: Int
    private(set) var forecasts: [Forecast]
    private(set) var city: City
}

extension WeeklyForecast: Storable {
    var isOutOfDate: Bool {
        return forecasts.first!.date.isMoreThanSinceNow(hour: 3)
    }

    var cacheKeys: [String] {
        var keys = [String]()
        forecasts.forEach { keys.append($0.moreWeather.first!.iconKey) }
        return keys
    }
}

extension WeeklyForecast: Codable {

    private enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
        case cnt
        case forecasts = "list"
        case city
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        message = try container.decode(Float.self, forKey: .message)
        cnt = try container.decode(Int.self, forKey: .cnt)
        forecasts = try container.decode([Forecast].self, forKey: .forecasts)
        city = try container.decode(City.self, forKey: .city)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
        try container.encode(cnt, forKey: .cnt)
        try container.encode(forecasts, forKey: .forecasts)
        try container.encode(city, forKey: .city)
    }
}
