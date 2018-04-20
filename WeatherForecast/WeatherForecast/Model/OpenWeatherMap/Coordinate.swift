//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 5..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Coordinate {

    private(set) var longitude: Double
    private(set) var latitude: Double
}

extension Coordinate: Codable {

    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        longitude = try container.decode(Double.self, forKey: .longitude)
        latitude = try container.decode(Double.self, forKey: .latitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
    }

}
