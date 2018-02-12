//
//  Extension+CLLocationCoordinate2D.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 12..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Decodable, Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude.isEqual(to: rhs.latitude) && lhs.longitude.isEqual(to: rhs.longitude)
    }

    func isChange(before coordinate: CLLocationCoordinate2D?) -> Bool {
        guard let c = coordinate else { return true }
        return self != c
    }

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
    }

}
