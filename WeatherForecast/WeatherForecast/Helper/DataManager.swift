//
//  DataManager.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct DataManager {

    func fetchForecastInfo(id: ID, completion: @escaping (ResponseResult) -> Void) {
        guard let url = WeatherAPI.url(id: id) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let result = self.processForecastRequest(data: data, error: error) else { return }
            completion(result)
        }.resume()
    }

    private func processForecastRequest(data: Data?, error: Error?) -> ResponseResult? {
        if let error = error { return .failure(error) }
        if let jsonData = data { return WeatherAPI.objectFromJSONData(data: jsonData) }
        return nil
    }
}
