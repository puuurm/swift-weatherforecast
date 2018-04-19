//
//  DataManagerTests.swift
//  WeatherForecastTests
//
//  Created by yangpc on 2018. 2. 9..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit
import Contacts

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var locationService: LocationService!
    let session = MockURLSession()

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager(session: session)
        locationService = LocationService()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_current_weather_url() {
        let location = CLLocation(latitude: 37.669812, longitude: 126.774540)
        locationService.convertToCityName(location: location) { [weak self] placeMark in
            guard let `self` = self else { return }
            guard let location = placeMark?.location,
                let postalAddress = placeMark?.postalAddress else { return }
            let address = Address(location: location, postalAddress: postalAddress)
            guard let url = API.url(
                baseURL: .current,
                parameters: QueryItem.coordinates(address: address)
            ) else { return }
            self.networkManager.request(
                QueryItem.coordinates(address: address),
                before: nil,
                baseURL: .current,
                type: CurrentWeather.self
            ) { _ -> Void in }
            XCTAssert(self.session.url == url)
        }
    }

    func test_weekley_forecast_url() {
        let location = CLLocation(latitude: 37.669812, longitude: 126.774540)
        locationService.convertToCityName(location: location) { [weak self] placeMark in
            guard let `self` = self else { return }
            guard let location = placeMark?.location,
                let postalAddress = placeMark?.postalAddress else { return }
            let address = Address(location: location, postalAddress: postalAddress)
            guard let url = API.url(
                baseURL: .weekly,
                parameters: QueryItem.coordinates(address: address)
                ) else { return }
            self.networkManager.request(
                QueryItem.coordinates(address: address),
                before: nil,
                baseURL: .weekly,
                type: CurrentWeather.self
            ) { _ -> Void in }
            XCTAssert(self.session.url == url)
        }
    }

    func test_flicker_json_url() {
        guard let url = API.url(
            baseURL: .photoList,
            parameters: QueryItem.photoSearch(tags: "sky")
        ) else { return }
        networkManager.request(
            QueryItem.photoSearch(tags: "sky"),
            before: nil,
            baseURL: .photoList,
            type: FlickerJSON.self
        ) { _ -> Void in }
        XCTAssert(self.session.url == url)
    }

    func test_flicker_image_url() {
        guard let url = API.url(
            baseURL: .photoList,
            parameters: QueryItem.photoSearch(tags: "sky")
        ) else { return }
        networkManager.request(
            QueryItem.photoSearch(tags: "sky"),
            before: nil,
            baseURL: .photoList,
            type: FlickerJSON.self
        ) { [weak self] result in
            switch result {
            case let .success(flickerJSON):
                guard let `self` = self else { return }
                self.networkManager.request(flickerJSON.photo(at: 0), imageExtension: .jpg) { _ -> Void in}
                XCTAssert(self.session.url == url)
            default: break
            }
        }
    }

    func test_start_request() {
        let location = CLLocation(latitude: 37.669812, longitude: 126.774540)
        locationService.convertToCityName(location: location) { [weak self] placeMark in
            guard let `self` = self else { return }
            guard let location = placeMark?.location,
                let postalAddress = placeMark?.postalAddress else { return }
            let address = Address(location: location, postalAddress: postalAddress)
            self.networkManager.request(
                QueryItem.coordinates(address: address),
                before: nil,
                baseURL: .current,
                type: CurrentWeather.self
            ) { _ -> Void in }
            XCTAssertTrue(self.session.dataTask.resumeWasCalled)
        }
    }
}

class MockURLSession: URLSessionProtocol {
    private(set) var url: URL?
    var dataTask = MockURLSessionDataTask()
    func dataTask(
        with url: URL,
        completionHandler: @escaping URLSessionProtocol.DataTaskResult
        ) -> URLSessionDataTaskProtocol {
        self.url = url
        return dataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}
