//
//  History.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation

final class History {
    private static var sharedInstance = History()
    static var shared: History {
        return sharedInstance
    }

    private var dataManager: DataManager
    private var currentWeathers: [CurrentWeather] = [] {
        didSet {
            reloadWeatherViewCell?()
        }
    }

    private var isNetworking: Bool = false {
        willSet {
            if newValue == true {
                onNetworkStatus?()
            } else {
                offNetworkStatus?()
            }
        }
    }

    var numberOfCell: Int {
        return currentWeathers.count
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    var onNetworkStatus: (() -> Void)?
    var offNetworkStatus: (() -> Void)?
    var reloadWeatherViewCell: (() -> Void)?

    private init() {
        dataManager = DataManager(session: URLSession.shared)
        currentWeathers = [CurrentWeather]()
    }

    // MARK: Internal Method
    func requestWeather(_ coordinate: CLLocationCoordinate2D) {
        if let coord = currentWeathers.first?.coordinate,
            !coordinate.isChange(before: coord) {
            return
        }
        var params: Query = coordinate.query
        params["units"] = "metric"
        isNetworking = true
        dataManager.fetchForecastInfo(
            baseURL: .weather,
            parameters: params,
            type: CurrentWeather.self) { [weak self] result -> Void in
                switch result {
                case let .success(r) :
                    OperationQueue.main.addOperation {
                        self?.currentWeathers.append(r)
                        self?.isNetworking = false
                    }
                case let .failure(error): print(error)
                }
        }
    }

    func coordinate(at index: Int) -> CLLocationCoordinate2D {
        return currentWeathers[index].coordinate
    }

    func delete(at indexPath: IndexPath) {
        currentWeathers.remove(at: indexPath.row)
    }

    func currentWeatherCell(at indexPath: IndexPath) -> WeatherTableCellViewModel {
        let currentWeather = currentWeathers[indexPath.row]
        return WeatherTableCellViewModel(
            timeString: dateFormatter.string(from: Date()),
            cityString: currentWeather.cityName,
            temperatureString: "\(currentWeather.weather.temperature)º")
    }

    func weatherDetailViewModel(at index: Int) -> WeatherDetailHeaderViewModel? {
        let currentWeather = currentWeathers[index]
        guard let weather = currentWeather.weatherDetail.last?.main else {
            return nil
        }
        return WeatherDetailHeaderViewModel (
            city: currentWeather.cityName,
            weather: weather,
            temperature: "\(currentWeather.weather.temperature)º",
            minTemperature: "\(currentWeather.weather.minTemperature)º",
            maxTemperature: "\(currentWeather.weather.maxTemperature)º" )
    }
}
