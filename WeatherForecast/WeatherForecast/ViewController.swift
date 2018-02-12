//
//  ViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var dataManager: DataManager?
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager(session: URLSession.shared)
        initLocationManager()
    }

}

extension ViewController: CLLocationManagerDelegate {
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate,
            coor.isChange(before: currentLocation) {
            locationManager?.stopMonitoringSignificantLocationChanges()
            let params = ["lat": coor.latitude.description, "lon": coor.longitude.description]
            dataManager?.fetchForecastInfo(parameters: params) { result -> Void in
                switch result {
                case let .success(r) : print(r)
                case let .failure(error): print(error)
                }
            }
            currentLocation = coor
        }
    }
}
