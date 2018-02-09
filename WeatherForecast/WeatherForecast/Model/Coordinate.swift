//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Coordinate: Decodable {
    private var longitude: Float
    private var latitude: Float

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        longitude = try container.decode(Float.self, forKey: .longitude)
        latitude = try container.decode(Float.self, forKey: .latitude)
    }

}
