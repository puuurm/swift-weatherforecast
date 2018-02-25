//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct WeatherAPI {

    static func url(baseURL: BaseURL, parameters: Query?) -> URL? {
        guard var components = URLComponents(string: baseURL.rawValue) else { return nil }
        var queryItems = [URLQueryItem]()
        if let params = parameters {
            for (key, value) in params {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        queryItems.append(URLQueryItem(name: "APPID", value: APIConstant.apiKey))
        components.queryItems = queryItems
        return components.url
    }

    static func objectFromJSONData<T: Decodable>(
        _ type: T.Type,
        data: Data
        ) -> ResponseResult<T> {
        do {
            let jsonObject =  try JSONDecoder().decode(type, from: data)
            return .success(jsonObject)
        } catch let error {
            return .failure(error)
        }
    }
}

enum CountryID: Int {
    case korea = 1835841
}

enum ResponseResult<T: Decodable> {
    case success(T)
    case failure(Error)
}

enum BaseURL: String {
    case weather = "https://api.openweathermap.org/data/2.5/weather"
    case forecast = "https://api.openweathermap.org/data/2.5/forecast"
}
