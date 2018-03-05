//
//  History.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 22..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import CoreLocation
import Contacts

final class History {

    private static var sharedInstance = History()
    static var shared: History {
        return sharedInstance
    }
    private var dataManager: DataManager
    private var currentWeathers: [CurrentWeather]
    private var localityList: [String]

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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    var onNetworkStatus: (() -> Void)?
    var offNetworkStatus: (() -> Void)?
    var reloadWeatherViewCell: (() -> Void)?

    private init() {
        dataManager = DataManager(session: URLSession.shared)
        currentWeathers = [CurrentWeather]()
        localityList = [String]()
    }

    private func updateCurrentWeather(_ newWeather: CurrentWeather) {
        if !currentWeathers.isEmpty {
            currentWeathers.remove(at: 0)
        }
        currentWeathers.insert(newWeather, at: 0)
        reloadWeatherViewCell?()
    }
    // MARK: Internal Method

    static func load(_ history: History) {
        sharedInstance = history
    }

    func requestWeather(_ placeMark: CLPlacemark) {
        guard let locality = placeMark.locality else { return }
        if let prev = localityList.first,
            locality == prev,
            let preUpdateTime = currentWeathers.first?.UTCOfLastupdate,
            !preUpdateTime.isMoreThanAnHourSinceNow {
            return
        }
        if !localityList.isEmpty { localityList.remove(at: 0) }
        localityList.insert(locality, at: 0)
        let params = ["q": locality, "units": "metric"]
        isNetworking = true
        dataManager.fetchForecastInfo(
            baseURL: .weather,
            parameters: params,
            type: CurrentWeather.self) { [weak self] result -> Void in
                switch result {
                case let .success(r) :
                    OperationQueue.main.addOperation {
                        self?.updateCurrentWeather(r)
                        self?.isNetworking = false
                    }
                case let .failure(error): print(error)
                }
        }
    }

    func localName(at index: Int) -> String {
        return localityList[index]
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
        case localityList
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentWeathers = try container.decode([CurrentWeather].self, forKey: .currentWeathers)
        localityList = try container.decode([String].self, forKey: .localityList)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentWeathers, forKey: .currentWeathers)
        try container.encode(localityList, forKey: .localityList)
    }

}
