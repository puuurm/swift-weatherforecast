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
    var storageManager = StorageManager()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        initData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if History.shared.count != 0 {
            NotificationCenter.default.post(name: Notification.Name.DidUpdateTime, object: self)
            NotificationCenter.default.post(name: Notification.Name.DidUpdateUserLocation, object: self)
            NotificationCenter.default.post(name: Notification.Name.DidUpdateAllCurrentWeather, object: self)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    private func initData() {
        if let object = try? storageManager.object(ofType: History.self, forKey: "history") {
            History.load(object)
        }
    }

    private func saveData() {
        do {
            try storageManager.setObject(History.shared, forKey: "history")
        } catch {
            print(error.localizedDescription)
        }
    }

}
