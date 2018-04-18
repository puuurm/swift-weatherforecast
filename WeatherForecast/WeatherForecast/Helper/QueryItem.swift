//
//  QueryItem.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 18..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct QueryItem {

    static func photoSearch(tags: String) -> [String: String] {
        return [
            "method": "flickr.photos.search",
            "api_key": Flicker.apiKey,
            "tags": tags,
            "tag_mode": "all",
            "text": "landscape",
            "page": "1",
            "per_page": "30",
            "format": "json",
            "content_type": "1",
            "nojsoncallback": "1"]
    }

    static func cityName(address: Address) -> [String: String] {
        return [
            "APPID": OpenWeatherMap.apiKey,
            "q": "\(address.subLocality),\(address.countryCode)",
            "units": "metric"
        ]
    }

    static func coordinates(address: Address) -> [String: String] {
        return [
            "APPID": OpenWeatherMap.apiKey,
            "lat": "\(address.coordinate.latitude)",
            "lon": "\(address.coordinate.longitude)",
            "units": "metric"
        ]
    }

}
