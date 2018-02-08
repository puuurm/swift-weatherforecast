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
    
    func test_weatherURL() {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=1835841")
        let testURL = WeatherAPI.url(id: .korea)
        XCTAssertEqual(testURL, url)
    }

}
