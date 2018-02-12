//
//  WeatherDetail.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct WeatherDetail: Decodable {
    private var identifier: Int
    private var main: String
    private var description: String
    private var icon: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id", main, description, pressure, icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(Int.self, forKey: .identifier)
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        icon = try container.decode(String.self, forKey: .icon)
    }

}
