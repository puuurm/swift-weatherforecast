//
//  ForecastStore.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation
import CoreLocation

struct ForecastStore {
    var localName: String
    var current: CurrentWeather?
    var weekly: WeeklyForecast?

    init(localName: String) {
        self.localName = localName
    }

    mutating func fetchData<T: Decodable>(object: T) {
        if let obj = object as? CurrentWeather {
            current = obj
        } else if let obj = object as? WeeklyForecast {
            weekly = obj
        }
    }
}

extension ForecastStore: Codable {

    private enum CodingKeys: String, CodingKey {
        case localName
        case current
        case weekly
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        localName = try container.decode(String.self, forKey: .localName)
        current = try? container.decode(CurrentWeather.self, forKey: .current)
        weekly = try? container.decode(WeeklyForecast.self, forKey: .weekly)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(localName, forKey: .localName)
        try? container.encode(current, forKey: .current)
        try? container.encode(weekly, forKey: .weekly)
    }
}
