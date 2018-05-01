//
//  Extension+Userdefaults.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 5. 1..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

protocol UnitUserDefaultable: AvailableKeyNamespace {
    associatedtype StringDefaultKey: RawRepresentable
}

// MARK: - UserDefault API Wrapper

extension UnitUserDefaultable where StringDefaultKey.RawValue == String {

    static func set(_ value: String, forKey key: StringDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    static func string(forKey key: StringDefaultKey) -> String? {
        let key = namespace(key)
        return UserDefaults.standard.string(forKey: key)
    }

    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}

extension UserDefaults {

    struct Unit: UnitUserDefaultable {
        enum StringDefaultKey: String {
            case temperature
            case windSpeed
        }
    }

}

protocol AvailableKeyNamespace {}

extension AvailableKeyNamespace {
    static func namespace<T>(_ key: T) -> String
        where T: RawRepresentable {
        return "\(Self.self).\(key.rawValue)"
    }
}
