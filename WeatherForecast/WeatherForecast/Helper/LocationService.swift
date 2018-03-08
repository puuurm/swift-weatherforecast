//
//  LocationService.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

final class LocationService: NSObject {

    private var locationManager: CLLocationManager?
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        initLocationManager()
    }

    private func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func searchCurrentLocation() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }

    static func locationToCity(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?.last
                completionHandler(firstLocation)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            delegate?.updateLocation(location)
            locationManager?.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

protocol LocationServiceDelegate: class {
    func updateLocation(_ location: CLLocation)
}
