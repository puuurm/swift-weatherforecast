//
//  Weather.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Weather {
    private(set) var temperature: Float
    private(set) var minTemperature: Float
    private(set) var maxTemperature: Float
    private(set) var pressure: Float
    private(set) var seaLevel: Float?
    private(set) var groundLevel: Float?
    private(set) var humidity: Int
}

extension Weather: Codable {

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try container.decode(Float.self, forKey: .temperature)
        minTemperature = try container.decode(Float.self, forKey: .minTemperature)
        maxTemperature = try container.decode(Float.self, forKey: .maxTemperature)
        pressure = try container.decode(Float.self, forKey: .pressure)
        seaLevel = try? container.decode(Float.self, forKey: .seaLevel)
        groundLevel = try? container.decode(Float.self, forKey: .groundLevel)
        humidity = try container.decode(Int.self, forKey: .humidity)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(minTemperature, forKey: .minTemperature)
        try container.encode(maxTemperature, forKey: .maxTemperature)
        try container.encode(pressure, forKey: .pressure)
        try? container.encode(seaLevel, forKey: .seaLevel)
        try? container.encode(groundLevel, forKey: .groundLevel)
        try container.encode(humidity, forKey: .humidity)
    }
}
