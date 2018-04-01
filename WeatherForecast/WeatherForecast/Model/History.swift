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
    var userLocationForecast: ForecastStore? {
        get {
            return forecastStores.first
        }
        set {
            updateUserLocationWeather(newValue)
        }
    }
    var forecastStores: [ForecastStore]

    var count: Int {
        return forecastStores.count
    }

    private init() {
        forecastStores = [ForecastStore]()
    }

    static func load(_ history: History) {
        self.sharedInstance = history
    }

    private func updateUserLocationWeather(_ forecastStore: ForecastStore?) {
        guard let forecast = forecastStore else { return }
        let userInfo: [String: Int] = ["index": 0]
        if forecastStores.isEmpty {
            forecastStores.append(forecast)
        } else {
            forecastStores[0] = forecast
            NotificationCenter.default.post(
                name: .DidUpdateCurrentWeather,
                object: self,
                userInfo: userInfo
            )
        }
    }

    func localName(at index: Int) -> String {
        return forecastStores[index].localName
    }

    func iconNames(at index: Int) -> [String] {
        return forecastStores[index].current.weatherDetail.map { $0.icon }
    }

    func append(_ forecastStore: ForecastStore) {
         let userInfo: [String: Int] = ["index": forecastStores.count]
        forecastStores.append(forecastStore)
        NotificationCenter.default.post(
            name: .DidInsertWeather,
            object: self,
            userInfo: userInfo
        )
    }

    func add(at index: Int, weeklyForecast: WeeklyForecast?) {
        guard let weekly = weeklyForecast else { return }
        forecastStores[index].weekly = weekly
    }

    func delete(at indexPath: IndexPath) {
        let userInfo: [String: Int] = ["index": indexPath.section]
        forecastStores.remove(at: indexPath.section)
        NotificationCenter.default.post(
            name: .DidDeleteWeather,
            object: self,
            userInfo: userInfo
        )
    }

    func temperatures(at index: Int) -> [Float] {
        return forecastStores[index].weekly?.forecasts.map { $0.mainWeather.temperature.rounded() } ?? []
    }

    func currentWeatherCell(at indexPath: IndexPath) -> WeatherTableCellViewModel {
        let currentWeather = forecastStores[indexPath.section].current
        return WeatherTableCellViewModel(
            timeString: Date().convertString(format: "h:mm a"),
            cityString: currentWeather.cityName,
            temperatureString: currentWeather.weather.temperature.convertCelsius,
            weatherDetail: currentWeather.weatherDetail.first!
        )
    }

    func weatherDetailViewModel(at index: Int) -> WeatherDetailHeaderViewModel? {
        let currentWeather = forecastStores[index].current
        guard let weatherDetail = currentWeather.weatherDetail.last?.main else {
            return nil
        }
        return WeatherDetailHeaderViewModel (
            city: currentWeather.cityName,
            weather: weatherDetail,
            temperature: currentWeather.weather.temperature.convertCelsius,
            minTemperature: currentWeather.weather.minTemperature.convertCelsius,
            maxTemperature: currentWeather.weather.maxTemperature.convertCelsius
        )
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
