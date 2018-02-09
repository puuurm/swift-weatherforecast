//
//  WeatherForecastTests.swift
//  WeatherForecastTests
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_fetchForecastInfo() {
        let dataManager = DataManager()
        var response: Response?
        dataManager.fetchForecastInfo(id: .korea) {
            (result) -> Void in
            switch result {
            case let .success(r) : response = r
            case let .failure(error): print(error)
            }
        }
        XCTAssertNotNil(response)
    }

}
