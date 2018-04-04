//
//  System.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 28..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct System {

    private(set) var type: Int = 0
    private(set) var identifier: Int = 0
    private(set) var message: Double = 0
    private(set) var country: String = ""
    private(set) var sunrise: TimeInterval = 0
    private(set) var sunset: TimeInterval = 0

}

extension System: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case identifier = "id"
        case message
        case country
        case sunrise
        case sunset
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try? container.decode(Int.self, forKey: .type)
        let identifier = try? container.decode(Int.self, forKey: .identifier)
        let message = try? container.decode(Double.self, forKey: .message)
        let country = try? container.decode(String.self, forKey: .country)
        let sunrise = try? container.decode(TimeInterval.self, forKey: .sunrise)
        let sunset = try? container.decode(TimeInterval.self, forKey: .sunset)
        self.type = type ?? 0
        self.identifier = identifier ?? 0
        self.message = message ?? 0
        self.country = country ?? ""
        self.sunrise = sunrise ?? 0
        self.sunset = sunset ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(type, forKey: .type)
        try? container.encode(identifier, forKey: .identifier)
        try? container.encode(message, forKey: .message)
        try? container.encode(country, forKey: .country)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)
    }
}
