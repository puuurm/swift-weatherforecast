//
//  WeatherContainer.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct WeatherContainer {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func fetchWeatherInfo(id: ID) {
        guard let url = WeatherAPI.url(id: id) else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            if let jsonData = data,
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                print(jsonString)
            }
        }
        task.resume()
    }
}
