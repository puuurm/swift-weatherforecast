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
        components.queryItems = parameters?.map { return URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }

    static func url(object: StorableImage, imageExtension: ImageExtension) -> URL? {
        let urlString = object.url.appending(imageExtension.rawValue)
        return URLComponents(string: urlString)?.url
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

enum ImageExtension: String {
    case jpg = ".jpg"
    case png = ".png"
}

enum BaseURL: String {
    case photoList = "https://api.flickr.com/services/rest/"
    case current = "https://api.openweathermap.org/data/2.5/weather"
    case weekly = "https://api.openweathermap.org/data/2.5/forecast"
}
