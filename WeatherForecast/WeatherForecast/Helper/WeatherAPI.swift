//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct WeatherAPI {

    private static let baseURLString = "https://api.openweathermap.org/data/2.5/forecast"

    static func url(id: ID) -> URL? {
        guard var components = URLComponents(string: baseURLString) else { return nil }
        var queryItems = [URLQueryItem]()
        let baseParams = ["id": String(id.rawValue), "APPID": APIConstant.apiKey]
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        components.queryItems = queryItems
        return components.url
    }

    static func objectFromJSONData(data: Data) -> ResponseResult {
        do {
            let jsonObject =  try JSONDecoder().decode(Response.self, from: data)
            return .success(jsonObject)
        } catch let error {
            return .failure(error)
        }
    }
}

enum ID: Int {
    case korea = 1835841
}

enum ResponseResult {
    case success(Response)
    case failure(Error)
}
