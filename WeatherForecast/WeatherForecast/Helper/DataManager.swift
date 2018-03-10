//
//  DataManager.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation
import UIKit

final class DataManager {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }

    func request<T>(
        _ localName: String,
        baseURL: BaseURL,
        type: T.Type,
        completion: @escaping ((ResponseResult<T>) -> Void)) {
        let params = ["q": localName, "units": "metric"]
        NetworkSpinner.on()
        guard let url = WeatherAPI.url(baseURL: baseURL, parameters: params) else { return }
        session.dataTask(with: url) { [weak self] (data, _, error) in
            guard let result = self?.processRequest(type, data: data, error: error) else { return }
            NetworkSpinner.off()
            completion(result)
        }.resume()
    }

    private func processRequest<T: Decodable>(
        _ type: T.Type,
        data: Data?,
        error: Error?
        ) -> ResponseResult<T>? {
        if let error = error {
            return .failure(error)
        }
        if let jsonData = data {
            return WeatherAPI.objectFromJSONData(type, data: jsonData)
        }
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
