//
//  Rain.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 4..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Rain {
    private(set) var volume3Hours: Float // Rain volume for the last 3 hours
}

extension Rain: Codable {
    private enum CodingKeys: String, CodingKey {
        case volume3Hours = "3h"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        volume3Hours = try container.decode(Float.self, forKey: .volume3Hours)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(volume3Hours, forKey: .volume3Hours)
    }
}
