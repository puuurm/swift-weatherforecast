//
//  City.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

struct City: Codable {
    private(set) var identifier: Int
    private(set) var name: String
    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var country: String

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case coordinate = "coord"
        case country
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(Int.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
        country = try container.decode(String.self, forKey: .country)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(country, forKey: .country)
    }

}
