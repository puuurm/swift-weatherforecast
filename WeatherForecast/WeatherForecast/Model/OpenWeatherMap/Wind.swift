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
        return "\(speed.convertWindSpeed()) \(degrees.convertDegrees())"
    }
}

extension Speed {

    func convertWindSpeed(to unit: String? = UserDefaults.Unit.string(forKey: .windSpeed)) -> String {
        let speed = ( unit == Unit.WindSpeed.mph.rawValue ? self.mphValue : self )
        return "\(Int(speed.rounded()))".appending(unit ?? Unit.WindSpeed.allTypes[0])
    }

    func convertDegrees() -> String {
        switch self {
        case 360, 0..<1: return"북풍"
        case 1..<90: return "북동풍"
        case 90..<91: return "동풍"
        case 91..<180: return "남동풍"
        case 180..<181: return "남풍"
        case 181..<270: return "남서풍"
        case 270: return "서풍"
        default: return "북서풍"
        }
    }

    var mphValue: Speed {
        return self*2.236936
    }
}
