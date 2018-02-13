//
//  Response.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Response: Decodable {
    private(set) var code: String
    private(set) var message: Float
    private(set) var cnt: Int
    private(set) var forecasts: [Forecast]
    private(set) var city: City

    enum CodingKeys: String, CodingKey {
        case code = "cod", message, cnt, forecasts = "list", city
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        message = try container.decode(Float.self, forKey: .message)
        cnt = try container.decode(Int.self, forKey: .cnt)
        forecasts = try container.decode([Forecast].self, forKey: .forecasts)
        city = try container.decode(City.self, forKey: .city)
    }
}
