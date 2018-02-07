//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

enum ID: Int {
    case korea = 1835841
}

struct WeatherAPI {
    private static let baseURLString = "https://api.openweathermap.org/data/2.5/forecast"

    static func weatherURL(id: ID) -> URL? {
        guard var components = URLComponents(string: baseURLString) else { return nil }
        var queryItems = [URLQueryItem]()
        let item = URLQueryItem(name: "id", value: String(id.rawValue))
        queryItems.append(item)
        components.queryItems = queryItems
        return components.url
    }

}
