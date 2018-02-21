//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct WeatherAPI {

    enum BaseURL: String {
        case currentWeather = "https://api.openweathermap.org/data/2.5/weather"
        case fiveDayThreeHour = "https://api.openweathermap.org/data/2.5/forecast"
    }

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

    static func objectFromJSONData<T>(
        _ type: T.Type,
        data: Data
        ) -> ResponseResult<T> where T: Decodable {
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

enum ResponseResult<T> where T: Decodable {
    case success(T)
    case failure(Error)
}
