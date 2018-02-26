//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 21..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

struct CurrentWeather {

    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var weatherDetail: [WeatherDetail]
    private(set) var weather: Weather
    private(set) var cityName: String
    private(set) var cityIdentifier: Int
    private(set) var timeOfLastupdate: Date
}

extension CurrentWeather: Decodable {
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weatherDetail = "weather"
        case weather = "main"
        case cityName = "name"
        case cityIdentifier = "id"
        case timeOfLastupdate = "dt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
        weatherDetail = try container.decode([WeatherDetail].self, forKey: .weatherDetail)
        weather = try container.decode(Weather.self, forKey: .weather)
        cityName = try container.decode(String.self, forKey: .cityName)
        cityIdentifier = try container.decode(Int.self, forKey: .cityIdentifier)
        timeOfLastupdate = try container.decode(Date.self, forKey: .timeOfLastupdate)
    }

}
