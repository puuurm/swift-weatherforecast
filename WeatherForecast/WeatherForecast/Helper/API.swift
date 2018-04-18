//
//  API.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

typealias Query = [String: String]

struct API {

    static func url(baseURL: BaseURL, parameters: Query?) -> URL? {
        guard var components = URLComponents(string: baseURL.rawValue) else { return nil }
        let queryItems = parameters?.map { return URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems = queryItems
        return components.url
    }

    static func iconURL(baseURL: BaseURL, key: String) -> URL? {
        guard let components = URLComponents(string: baseURL.rawValue)?.url else { return nil }
        return components.appendingPathComponent(key.appending(".png"))
    }

    static func imageURL(photo: Photo) -> URL? {
        let urlString = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        guard let components = URLComponents(string: urlString)?.url else { return nil }
        return components
    }

    static func objectFromJSONData<T: Decodable>(
        _ type: T.Type,
        data: Data
        ) -> ResponseResult<T> {
        do {
            let object = try DataSerializer.deserialize(data: data) as T
            return .success(object)
        } catch {
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
    case photoList = "https://api.flickr.com/services/rest/"
    case current = "https://api.openweathermap.org/data/2.5/weather"
    case weekly = "https://api.openweathermap.org/data/2.5/forecast"
    case icon = "https://openweathermap.org/img/w/"
}
