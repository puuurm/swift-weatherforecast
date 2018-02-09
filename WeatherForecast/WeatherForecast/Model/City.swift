//
//  City.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct City: Decodable {
    private var id: Int
    private var name: String
    private var coordinate: Coordinate
    private var country: String

    enum CodingKeys: String, CodingKey {
        case id, name, coordinate = "coord", country
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        country = try container.decode(String.self, forKey: .country)
    }

}
