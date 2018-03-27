//
//  LocationService.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func updateLocation(_ placeMark: CLPlacemark?)
}

final class LocationService: NSObject, Presentable {

    typealias AfterTask = ((CLPlacemark?) -> Void)

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

    private func coordinateToCityName(location: CLLocation, completionHandler: @escaping AfterTask) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error as? CLError {
                self?.presentErrorMessage(message: error.localizedDescription)
                return
            }
            completionHandler(placemarks?.last)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            coordinateToCityName(location: location) { [weak self] (placeMark) in
                self?.delegate?.updateLocation(placeMark)
            }
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            if error.code == .denied {
                manager.stopUpdatingLocation()
            }
            presentErrorMessage(message: error.localizedDescription)
        }
    }
}
