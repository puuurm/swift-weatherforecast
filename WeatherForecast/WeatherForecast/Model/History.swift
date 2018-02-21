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
    private var coordinates: [CLLocationCoordinate2D] = [] {
        willSet {
            if let c = newValue.last {
                updateCurrentLocation(c)
            }
        }
    }
    private var currentWeathers: [CurrentWeather] = [] {
        willSet {
            if let c = newValue.last {
                cellViewModel(c)
            }
        }
    }

    private var weatherViewCellModels: [WeatherTableCellViewModel] = [] {
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
        return weatherViewCellModels.count
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
        coordinates = [CLLocationCoordinate2D]()
        currentWeathers = [CurrentWeather]()
    }

    // MARK: Internal Method
    func add(_ coordinate: CLLocationCoordinate2D) {
        coordinates.append(coordinate)
    }

    func updateCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        isNetworking = true
        var params: Query = coordinate.query
        params["units"] = "metric"
        dataManager.fetchForecastInfo(
            baseURL: .currentWeather,
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

    func cellViewModel(at indexPath: IndexPath) -> WeatherTableCellViewModel {
        return weatherViewCellModels[indexPath.row]
    }

    func cellViewModel(_ currentWeather: CurrentWeather) {
        let cell = WeatherTableCellViewModel(
            timeString: dateFormatter.string(from: Date()),
            cityString: currentWeather.cityName,
            temperatureString: "\(currentWeather.weather.temperature)°"
        )
        weatherViewCellModels.append(cell)
    }
}
