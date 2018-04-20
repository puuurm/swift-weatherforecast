//
//  Photo.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 19..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Photo {

    private(set) var photoKey: String = UUID().uuidString
    private(set) var farm: Int
    private(set) var id: String
    private(set) var server: String
    private(set) var secret: String
    private(set) var title: String
}

extension Photo: Codable {

    private enum CodingKeys: String, CodingKey {
        case farm
        case id
        case server
        case secret
        case title
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        farm = try container.decode(Int.self, forKey: .farm)
        id = try container.decode(String.self, forKey: .id)
        server = try container.decode(String.self, forKey: .server)
        secret = try container.decode(String.self, forKey: .secret)
        title = try container.decode(String.self, forKey: .title)
        photoKey = UUID().uuidString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(farm, forKey: .farm)
        try container.encode(id, forKey: .id)
        try container.encode(server, forKey: .server)
        try container.encode(secret, forKey: .secret)
        try container.encode(title, forKey: .title)
    }
}

extension Photo: StorableImage {

    var url: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)"
    }

    var cacheKey: String {
        return photoKey
    }
}
