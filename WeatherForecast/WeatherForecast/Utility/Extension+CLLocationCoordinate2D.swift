//
//  Extension+CLLocationCoordinate2D.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 12..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

typealias Query = [String: String]

extension CLLocationCoordinate2D: Decodable {

    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }

    var query: Query {
        return [CodingKeys.latitude.rawValue: latitude.description,
                CodingKeys.longitude.rawValue: longitude.description]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
    }

    func isChange(before coordinate: CLLocationCoordinate2D?) -> Bool {
        guard let c = coordinate else { return true }
        return self != c
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude.isEqual(to: rhs.latitude) && lhs.longitude.isEqual(to: rhs.longitude)
    }
}
