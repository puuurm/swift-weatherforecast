//
//  Address.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 4..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation
import Contacts

struct Address: Codable {

    private(set) var countryCode: String
    private(set) var state: String
    private(set) var city: String
    private(set) var street: String
    private(set) var subLocality: String

    private(set) var subAdministrativeArea: String

    var queryItem: String {
        return "\(subLocality),\(countryCode)"
    }

    init(postalAddress: CNPostalAddress) {
        countryCode = postalAddress.isoCountryCode.lowercased()
        state = postalAddress.state
        city = postalAddress.city
        street = postalAddress.street
        subLocality = postalAddress.subLocality
        subAdministrativeArea = postalAddress.subAdministrativeArea
    }
}
