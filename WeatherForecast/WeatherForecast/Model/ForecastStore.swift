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
    var address: Address
    var current: CurrentWeather
    var weekly: WeeklyForecast?

    init(address: Address, current: CurrentWeather) {
        self.address = address
        self.current = current
    }
}

extension ForecastStore: Codable {

    private enum CodingKeys: String, CodingKey {
        case address
        case current
        case weekly
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(Address.self, forKey: .address)
        current = try container.decode(CurrentWeather.self, forKey: .current)
        weekly = try? container.decode(WeeklyForecast.self, forKey: .weekly)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(current, forKey: .current)
        try? container.encode(weekly, forKey: .weekly)
    }
}
