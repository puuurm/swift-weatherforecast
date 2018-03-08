//
//  History.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//
import Foundation
import CoreLocation

final class History {

    private static var sharedInstance = History()
    static var shared: History {
        return sharedInstance
    }

    var dataManager: DataManager?
    private var forecastStores: [ForecastStore]
    private var isNetworking: Bool = false {
        willSet {
            if newValue == true {
                onNetworkStatus?()
            } else {
                offNetworkStatus?()
            }
        }
    }
    var onNetworkStatus: (() -> Void)?
    var offNetworkStatus: (() -> Void)?
    var count: Int {
        return forecastStores.count
    }
    var reloadWeatherViewCell: (() -> Void)?

    private init() {
        dataManager = DataManager(session: URLSession.shared)
        forecastStores = [ForecastStore]()
    }

    static func load(_ history: History) {
        self.sharedInstance = history
    }

    func localName(at index: Int) -> String {
        return forecastStores[index].localName
    }

    func delete(at indexPath: IndexPath) {
        forecastStores.remove(at: indexPath.row)
    }

    func hasValue(at index: Int) -> Bool {
        if forecastStores.count > index { return true }
        return false
    }

    func isWeatherNeedUpdate(_ localName: String, index: Int) -> Bool {
        guard hasValue(at: index),
            forecastStores[index].localName == localName,
            let current = forecastStores[index].current,
            !current.isOutOfDate else {
                return true
        }
        return false
    }

    func updateLocation(_ localName: String, index: Int) {
        if forecastStores.count <= index {
            forecastStores.append(ForecastStore(localName: localName))
        } else {
            forecastStores[index].localName = localName
        }
    }

    func updateWeather() {
        var i = 0
        forecastStores.forEach {
            let localName = $0.localName
            self.updateCurrentWeather(
                at: i,
                localName: localName,
                baseURL: .current,
                type: CurrentWeather.self
            )
            i += 1
        }
    }

    func updateCurrentWeather<T: Decodable>(
        at index: Int,
        localName: String,
        baseURL: BaseURL,
        type: T.Type) {
        guard isWeatherNeedUpdate(localName, index: index) else { return }
        updateLocation(localName, index: index)
        isNetworking = true
        dataManager?.request(
            localName,
            baseURL: baseURL,
            type: type
        ) { [weak self] result -> Void in
            switch result {
            case let .success(weather):
                self?.forecastStores[index].fetchData(object: weather)
                OperationQueue.main.addOperation { [weak self] in
                    self?.reloadWeatherViewCell?()
                    self?.isNetworking = false
                }
            case let .failure(error): print(error)
            }
        }
    }

    func currentWeatherCell(at indexPath: IndexPath) -> WeatherTableCellViewModel? {
        guard let currentWeather = forecastStores[indexPath.row].current else {
            return nil
        }
        return WeatherTableCellViewModel(
            timeString: Date().convertString(format: "HH:mm"),
            cityString: currentWeather.cityName,
            temperatureString: "\(currentWeather.weather.temperature)º")
    }

    func weatherDetailViewModel(at index: Int) -> WeatherDetailHeaderViewModel? {
        guard let currentWeather = forecastStores[index].current,
            let weatherDetail = currentWeather.weatherDetail.last?.main else {
            return nil
        }
        return WeatherDetailHeaderViewModel (
            city: currentWeather.cityName,
            weather: weatherDetail,
            temperature: "\(currentWeather.weather.temperature)º",
            minTemperature: "\(currentWeather.weather.minTemperature)º",
            maxTemperature: "\(currentWeather.weather.maxTemperature)º" )
    }

}

extension History: Codable {

    private enum CodingKeys: String, CodingKey {
        case forecastStores
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        forecastStores = try container.decode([ForecastStore].self, forKey: .forecastStores)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(forecastStores, forKey: .forecastStores)
    }
}
