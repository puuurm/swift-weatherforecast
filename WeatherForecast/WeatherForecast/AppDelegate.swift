//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        initLocationManager()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

//extension AppDelegate: CLLocationManagerDelegate {
//    func initLocationManager() {
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.requestWhenInUseAuthorization()
//        locationManager?.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let coor = manager.location?.coordinate,
//            coor.isChange(before: currentLocation) {
//            print("lat: \(coor.latitude) long: \(coor.longitude)")
//            locationManager?.stopMonitoringSignificantLocationChanges()
//            if let rootVC = window?.rootViewController as? ViewController {
//                let params = ["lat": coor.latitude.description, "lon":  coor.longitude.description]
//                rootVC.dataManager?.fetchForecastInfo(parameters: params) {
//                    (result) -> Void in
//                    switch result {
//                    case let .success(r) : print(r)
//                    case let .failure(error): print(error)
//                    }
//                }
//
//            }
//            currentLocation = coor
//        }
//
//    }
//
//}

