//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 21..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

struct CurrentWeather {

    private(set) var coordinate: Coordinate
    private(set) var weatherDetail: [WeatherDetail]
    private(set) var weather: Weather
    private(set) var wind: Wind?
    private(set) var clouds: Clouds?
    private(set) var rain: Rain?
    private(set) var snow: Snow?
    private(set) var cityName: String
    private(set) var cityIdentifier: Int?
    private var timeOfLastupdate: TimeInterval
    private(set) var system: System
    private var cod: Int
}

extension CurrentWeather: Storable {

    var cacheKeys: [String] {
        guard let key = weatherDetail.first?.iconKey else {
            return []
        }
        return [key]
    }

    var isOutOfDate: Bool {
        let lastUpdate = Date(timeIntervalSince1970: timeOfLastupdate)
        return lastUpdate.isMoreThanSinceNow(hour: 1)
    }

}

extension CurrentWeather: Codable {

    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weatherDetail = "weather"
        case weather = "main"
        case wind
        case clouds
        case rain
        case snow
        case cityName = "name"
        case cityIdentifier = "id"
        case timeOfLastupdate = "dt"
        case system = "sys"
        case cod
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        weatherDetail = try container.decode([WeatherDetail].self, forKey: .weatherDetail)
        weather = try container.decode(Weather.self, forKey: .weather)

        wind = try? container.decode(Wind.self, forKey: .wind)
        clouds = try? container.decode(Clouds.self, forKey: .clouds)
        rain = try? container.decode(Rain.self, forKey: .rain)
        snow = try? container.decode(Snow.self, forKey: .snow)

        cityName = try container.decode(String.self, forKey: .cityName)

        cityIdentifier = try? container.decode(Int.self, forKey: .cityIdentifier)

        timeOfLastupdate = try container.decode(TimeInterval.self, forKey: .timeOfLastupdate)
        system = try container.decode(System.self, forKey: .system)
        cod = try container.decode(Int.self, forKey: .cod)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(weatherDetail, forKey: .weatherDetail)
        try container.encode(weather, forKey: .weather)
        try? container.encode(wind, forKey: .wind)
        try? container.encode(clouds, forKey: .clouds)
        try? container.encode(rain, forKey: .rain)
        try? container.encode(snow, forKey: .snow)
        try container.encode(cityName, forKey: .cityName)
        try? container.encode(cityIdentifier, forKey: .cityIdentifier)
        try container.encode(timeOfLastupdate, forKey: .timeOfLastupdate)
        try container.encode(system, forKey: .system)
        try container.encode(cod, forKey: .cod)
    }
}
