//
//  WeatherDetail.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct WeatherDetail {

    private(set) var identifier: Int?
    private(set) var main: String?
    private(set) var description: String?
    private(set) var icon: String
    private(set) var iconKey: String

}

extension WeatherDetail: Codable {

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case main
        case description
        case pressure
        case icon
        case iconKey
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try? container.decode(Int.self, forKey: .identifier)
        main = try? container.decode(String.self, forKey: .main)
        description = try? container.decode(String.self, forKey: .description)
        icon = try container.decode(String.self, forKey: .icon)
        if let iconKey = try? container.decode(String.self, forKey: .iconKey) {
            self.iconKey = iconKey
        } else {
            self.iconKey = UUID().uuidString
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(identifier, forKey: .identifier)
        try? container.encode(main, forKey: .main)
        try? container.encode(description, forKey: .description)
        try container.encode(icon, forKey: .icon)
        try container.encode(iconKey, forKey: .iconKey)
    }

}

extension WeatherDetail: StorableImage {

    var url: String {
        return "https://openweathermap.org/img/w/\(icon)"
    }

    var cacheKey: String {
        return iconKey
    }

}
