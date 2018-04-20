//
//  Photos.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 19..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Photos: Codable {

    private(set) var page: Int
    private(set) var pages: Int
    private(set) var perpage: Int
    private(set) var total: String
    private(set) var photo: [Photo]

}
