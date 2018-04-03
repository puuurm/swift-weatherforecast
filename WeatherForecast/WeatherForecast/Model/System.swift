//
//  System.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 28..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct System {
    private(set) var type: Int?
    private(set) var identifier: Int?
    private(set) var message: Double
    private(set) var country: String
    private(set) var sunrise: TimeInterval
    private(set) var sunset: TimeInterval
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
        type = try? container.decode(Int.self, forKey: .type)
        identifier = try? container.decode(Int.self, forKey: .identifier)
        message = try container.decode(Double.self, forKey: .message)
        country = try container.decode(String.self, forKey: .country)
        sunrise = try container.decode(TimeInterval.self, forKey: .sunrise)
        sunset = try container.decode(TimeInterval.self, forKey: .sunset)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(type, forKey: .type)
        try? container.encode(identifier, forKey: .identifier)
        try container.encode(message, forKey: .message)
        try container.encode(country, forKey: .country)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)
    }
}
