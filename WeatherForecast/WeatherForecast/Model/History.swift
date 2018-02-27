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
    private var currentWeathers = [CurrentWeather]()

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

    static func load(_ history: History) {
        sharedInstance = history
    }

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

extension History: Codable {
    enum CodingKeys: String, CodingKey {
        case currentWeathers
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentWeathers = try container.decode([CurrentWeather].self, forKey: .currentWeathers)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentWeathers, forKey: .currentWeathers)
    }

}

class HistoryManager {
    private enum Key: String {
        case history
    }
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    func save() {
        var data = Data()
        do {
            data = try encoder.encode(History.shared)
        } catch {
            print(error.localizedDescription)
        }
        UserDefaults.standard.set(data, forKey: Key.history.rawValue)
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: Key.history.rawValue) else {
            return
        }
        do {
            let history = try decoder.decode(History.self, from: data)
            History.load(history)
        } catch {
            print(error.localizedDescription)
        }
    }
}
