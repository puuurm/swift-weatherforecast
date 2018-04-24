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
    lazy var clock = Clock()
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

    func updateCurrentWeather(at index: Int, forecastStore: ForecastStore?) {
        guard let forecast = forecastStore else { return }
        let userInfo: [String: Int] = ["index": index]
        if forecastStores.count > index {
            forecastStores[index] = forecast
            NotificationCenter.default.post(
                name: .DidUpdateCurrentWeather,
                object: self,
                userInfo: userInfo
            )
        } else {
            append(forecast)
        }
    }

    func updateWeeklyWeather(at index: Int, weekly: WeeklyForecast) {
        forecastStores[index].weekly = weekly
        NotificationCenter.default.post(name: .DidUpdateWeeklyWeather, object: nil)
    }

    func address(at index: Int) -> Address {
        return forecastStores[index].address
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

    func weekly(at index: Int) -> WeeklyForecast? {
        guard forecastStores.count > index,
            let weekly = forecastStores[index].weekly else { return nil }
        return weekly
    }

    func temperatures(at index: Int) -> [Float] {
        return forecastStores[index].weekly?.forecasts.map { $0.mainWeather.temperature.rounded() } ?? []
    }

    func currentWeatherCell(at indexPath: IndexPath) -> WeatherTableCellViewModel {
        let cityName = forecastStores[indexPath.section].address.subLocality
        let currentWeather = forecastStores[indexPath.section].current
        let isUserLocation = indexPath.section == 0 ? true : false
        return WeatherTableCellViewModel(
            cityString: cityName,
            temperatureString: currentWeather.weather.temperature.convertCelsius,
            weatherDetail: currentWeather.weatherDetail.first!,
            isUserLocation: isUserLocation
        )
    }

    func currentDetailCell(at index: Int, row: Int) -> CurrentDetailCellViewModel {
        let current = forecastStores[index].current
        let list = CurrentDetailList(current: current)
        return list.currentDetailCellViewModel(at: row)
    }

    func currentDetailCount(at index: Int) -> Int {
        let current = forecastStores[index].current
        return CurrentDetailList(current: current).count
    }

    func weatherDetailViewModel(at index: Int) -> WeatherDetailHeaderViewModel? {
        let cityName = forecastStores[index].address.subLocality
        let currentWeather = forecastStores[index].current
        guard let weatherDetail = currentWeather.weatherDetail.last?.main else {
            return nil
        }
        return WeatherDetailHeaderViewModel (
            city: cityName,
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
