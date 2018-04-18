//
//  PhotoList.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 18..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

struct FlickerJSON: Codable {
    private(set) var photos: Photos
    private(set) var stat: String

    func photoObejct(at index: Int) -> Photo? {
        return photos.photo[index]
    }

}

struct Photos: Codable {
    private(set) var page: Int
    private(set) var pages: Int
    private(set) var perpage: Int
    private(set) var total: String
    private(set) var photo: [Photo]
}

struct Photo {
    private(set) var cacheKey: String = UUID().uuidString
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
        cacheKey = UUID().uuidString
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

