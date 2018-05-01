//
//  Wind.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 4..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

typealias Speed = Float

struct Wind {

    private(set) var speed: Speed
    private(set) var degrees: Float

}

extension Wind: Codable {

    private enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(Speed.self, forKey: .speed)
        degrees = try container.decode(Float.self, forKey: .degrees)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(speed, forKey: .speed)
        try container.encode(degrees, forKey: .degrees)
    }

}

extension Wind: AvailableDetailWeather {

    var image: UIImage {
        return UIImage.Icons.Weather.Wind
    }

    var title: String {
        return "wind"
    }

    var contents: String {
        return "\(speed)m/s \(degrees)"
    }
}
