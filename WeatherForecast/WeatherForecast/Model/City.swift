//
//  City.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

struct City: Decodable {
    private var identifier: Int
    private var name: String
    private var coordinate: CLLocationCoordinate2D
    private var country: String

    enum CodingKeys: String, CodingKey {
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

}
