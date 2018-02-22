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
    private var weatherDetail: [WeatherDetail]
    private(set) var weather: Weather
    private(set) var cityName: String
    private(set) var timeOfLastupdate: Int
}

extension CurrentWeather: Decodable {
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weatherDetail = "weather"
        case weather = "main"
        case cityName = "name"
        case timeOfLastupdate = "dt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
        weatherDetail = try container.decode([WeatherDetail].self, forKey: .weatherDetail)
        weather = try container.decode(Weather.self, forKey: .weather)
        cityName = try container.decode(String.self, forKey: .cityName)
        timeOfLastupdate = try container.decode(Int.self, forKey: .timeOfLastupdate)
    }

}
