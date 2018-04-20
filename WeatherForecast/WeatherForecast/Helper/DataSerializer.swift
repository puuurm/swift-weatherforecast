//
//  DataSerializer.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 5..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

final class DataSerializer {

    static func serialize<T: Encodable>(object: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(object)
    }

    static func deserialize<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

}
