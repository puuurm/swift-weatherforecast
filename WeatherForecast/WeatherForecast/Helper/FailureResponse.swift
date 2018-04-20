//
//  FailureResponse.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 5..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct FailureResponse {

    let statusCode: Int

    var error: HttpError {
        switch statusCode {
        case 404: return HttpError.notFound
        case 300...307: return HttpError.redirection
        case 400...417: return HttpError.clientError
        default: return HttpError.serverError
        }
    }

    enum HttpError: Error, LocalizedError {
        case redirection    // 3xx
        case clientError    // 4xx
        case notFound       // 404
        case serverError    // 5xx

        var errorDescription: String? {
            switch self {
            case .notFound: return "HTTP Not Found"
            case .redirection: return "redirection"
            case .clientError: return "Client Error"
            case .serverError: return "Server Error"
            }
        }
    }

}
