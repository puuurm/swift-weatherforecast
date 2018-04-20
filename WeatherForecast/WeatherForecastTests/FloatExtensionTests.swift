//
//  FloatExtensionTests.swift
//  WeatherForecastTests
//
//  Created by yangpc on 2018. 4. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import XCTest

class FloatExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_convertCelsius_minus_zero_point_two() {
        let num: Float = -0.2
        XCTAssertTrue(num.convertCelsius == "0º")
    }

    func test_convertCelsius_zero() {
        let num: Float = -0.2
        XCTAssertTrue(num.convertCelsius == "0º")
    }

    func test_convertCelsius_minus_zero_point_seven() {
        let num: Float = -0.7
        XCTAssertTrue(num.convertCelsius == "-1º")
    }

    func test_convertCelsius_zero_point_three() {
        let num: Float = 0.3
        XCTAssertTrue(num.convertCelsius == "0º")
    }

    func test_convertCelsius_zero_point_seven() {
        let num: Float = 0.7
        XCTAssertTrue(num.convertCelsius == "1º")
    }

}
