//
//  Wind.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 4..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Wind {
    private(set) var speed: Float?
    private(set) var degrees: Int?
}

extension Wind: Codable {
    private enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try? container.decode(Float.self, forKey: .speed)
        degrees = try? container.decode(Int.self, forKey: .degrees)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(speed, forKey: .speed)
        try? container.encode(degrees, forKey: .degrees)
    }
}
