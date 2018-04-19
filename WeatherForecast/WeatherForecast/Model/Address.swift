//
//  Address.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 4..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation
import MapKit
import Contacts

struct Address: Codable {

    private(set) var countryCode: String
    private(set) var coordinate: Coordinate
    private(set) var state: String?
    private(set) var city: String?
    private(set) var street: String?
    private(set) var subLocality: String

    private(set) var subAdministrativeArea: String?

    init(location: CLLocation, postalAddress: CNPostalAddress) {
        coordinate = Coordinate(
            longitude: location.coordinate.longitude,
            latitude: location.coordinate.latitude
        )
        countryCode = postalAddress.isoCountryCode
        state = postalAddress.state
        city = postalAddress.city
        street = postalAddress.street
        subLocality = postalAddress.subLocality
        subAdministrativeArea = postalAddress.subAdministrativeArea
    }

    init(name: String, placeMark: MKPlacemark) {
        subLocality = name
        countryCode = placeMark.countryCode ?? "Unknown"
        coordinate = Coordinate(
            longitude: placeMark.coordinate.longitude,
            latitude: placeMark.coordinate.latitude
        )
    }

}
