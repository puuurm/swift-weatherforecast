//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 8..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation
import UIKit

final class NetworkManager {

    private let session: URLSessionProtocol
    private var imageCache: ImageCache
    typealias ImageHandler = ((ImageResult) -> Void)

    struct Http {
        static let Success = 200
    }

    init(session: URLSessionProtocol) {
        self.session = session
        imageCache = ImageCache()
    }

    func request<T>(
        _ params: [String: String],
        before object: Storable?,
        baseURL: BaseURL,
        type: T.Type,
        completion: @escaping ((ResponseResult<T>) -> Void)) {

        guard let url = WeatherAPI.url(baseURL: baseURL, parameters: params) else { return }
        NetworkSpinner.on()
        session.dataTask(with: url) { [weak self] (data, response, _) in
            guard let httpResponse = response as? HTTPURLResponse, let `self` = self else { return }
            let result = self.processRequest(type, response: httpResponse, data: data)
            completion(result)
            self.imageCache.deleteImageForkeys(keys: object?.cacheKeys)
            NetworkSpinner.off()
        }.resume()

    }

    func request(
        _ weatherDetail: WeatherDetail,
        baseURL: BaseURL,
        completion: @escaping ImageHandler) {
        if let image = imageCache.imageForKey(key: weatherDetail.iconKey) {
            completion(.success(image))
            return
        }
        guard let url = WeatherAPI.iconURL(baseURL: baseURL, key: weatherDetail.icon) else { return }
        NetworkSpinner.on()
        session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            let status = httpResponse.statusCode
            if status == Http.Success,
                let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(FailureResponse(statusCode: status).error))
            }
            NetworkSpinner.off()
        }.resume()
    }

    private func processRequest<T: Decodable>(
        _ type: T.Type,
        response: HTTPURLResponse,
        data: Data?
        ) -> ResponseResult<T> {

        let status = response.statusCode
        if status == Http.Success,
            let jsonData = data {
            return WeatherAPI.objectFromJSONData(type, data: jsonData)
        } else {
            return .failure(FailureResponse(statusCode: status).error)
        }

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

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}
