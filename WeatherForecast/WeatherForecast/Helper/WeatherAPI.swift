//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

typealias Query = [String: String]

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

    static func url(baseURL: BaseURL, key: String) -> URL? {
        guard let components = URLComponents(string: baseURL.rawValue)?.url else { return nil }
        return components.appendingPathComponent(key.appending(".png"))
    }

    static func objectFromJSONData<T: Decodable>(
        _ type: T.Type,
        data: Data
        ) -> ResponseResult<T> {
        do {
            let object = try DataSerializer.deserialize(data: data) as T
            return .success(object)
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
    case current = "https://api.openweathermap.org/data/2.5/weather"
    case weekly = "https://api.openweathermap.org/data/2.5/forecast"
    case icon = "https://openweathermap.org/img/w/"
}
