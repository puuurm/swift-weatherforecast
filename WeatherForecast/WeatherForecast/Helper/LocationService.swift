//
//  LocationService.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

class LocationService: NSObject {
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
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = manager.location?.coordinate {
            delegate?.updateLocation(coordinate)
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

protocol LocationServiceDelegate: class {
    func updateLocation(_ coordinate: CLLocationCoordinate2D)
}
