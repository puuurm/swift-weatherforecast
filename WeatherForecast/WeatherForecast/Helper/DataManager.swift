//
//  DataManager.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct DataManager {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }

    func fetchForecastInfo(
        parameters: [String: String]?,
        completion: @escaping (ResponseResult) -> Void) {
        guard let url = WeatherAPI.url(parameters: parameters) else { return }
        session.dataTask(with: url) { (data, _, error) in
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

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(
        with url: URL,
        completionHandler: @escaping DataTaskResult
        ) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping URLSessionProtocol.DataTaskResult
        ) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler)
            as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }
