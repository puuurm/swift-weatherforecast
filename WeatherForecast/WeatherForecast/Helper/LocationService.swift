//
//  LocationService.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func updateLocation(_ placeMark: CLPlacemark?, error: Error?)
}

final class LocationService: NSObject {

    typealias AfterTask = ((CLPlacemark?, Error?) -> Void)

    private var locationManager: CLLocationManager?
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        initLocationManager()
    }

    private func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
    }

    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse,
            !CLLocationManager.locationServicesEnabled() {
            return
        }
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }

    func coordinateToCityName(location: CLLocation, completionHandler: @escaping AfterTask) {
        let geocoder = CLGeocoder()
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?.last
                completionHandler(firstLocation, nil)
            } else {
                completionHandler(nil, error!)
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            coordinateToCityName(location: location) { [weak self] (placeMark, error) in
                self?.delegate?.updateLocation(placeMark, error: error)
            }
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            // Location updates are not authorized.
            if error.code == .denied {
                manager.stopUpdatingLocation()
            }
            delegate?.updateLocation(nil, error: error)
        }
    }
}
