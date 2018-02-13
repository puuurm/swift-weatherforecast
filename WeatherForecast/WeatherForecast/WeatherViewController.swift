//
//  ViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!

    var dataManager: DataManager?
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    var response: Response? {
        didSet {
            weatherTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager(session: URLSession.shared)
        initLocationManager()
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let cellId = "WeatherTableViewCell"
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellId,
            for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.cityLabel.text = response?.city.name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
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
                case let .success(r) :
                    OperationQueue.main.addOperation {
                        self.response = r
                    }
                case let .failure(error): print(error)
                }
            }
            currentLocation = coor
        }
    }
}
