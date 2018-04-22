//
//  Clouds.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 4..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

struct Clouds {

    private(set) var all: Int // Cloudiness, %

}

extension Clouds: Codable {

    private enum CodingKeys: String, CodingKey {
        case all
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        all = try container.decode(Int.self, forKey: .all)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(all, forKey: .all)
    }

}

extension Clouds: AvailableDetailWeather {

    var image: UIImage {
        return UIImage.Icons.Weather.Clouds
    }

    var title: String {
        return "clouds"
    }

    var contents: String {
        return "\(all)%"
    }


}

