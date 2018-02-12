//
//  DataManagerTests.swift
//  WeatherForecastTests
//
//  Created by yangpc on 2018. 2. 9..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import XCTest

class DataManagerTests: XCTestCase {
    var dataManager: DataManager!
    let session = MockURLSession()

    let params = ["lat": "37.785834", "lon":  "-122.406417"]

    override func setUp() {
        super.setUp()
        dataManager = DataManager(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_url() {
        guard let url = WeatherAPI.url(parameters: params) else { return }
        dataManager.fetchForecastInfo(parameters: params) { _ -> Void in}
        XCTAssert(session.url == url)
    }

    func test_start_request() {
        dataManager.fetchForecastInfo(parameters: params) { _ -> Void in }
        XCTAssertTrue(session.dataTask.resumeWasCalled)
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
