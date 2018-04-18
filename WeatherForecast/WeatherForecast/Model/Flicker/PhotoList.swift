//
//  PhotoList.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 18..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct FlickerJSON: Codable {
    private(set) var photos: Photos
    private(set) var stat: String
}

struct Photos: Codable {
    private(set) var page: Int
    private(set) var pages: Int
    private(set) var perpage: Int
    private(set) var total: String
    private(set) var photo: [Photo]
}

struct Photo: Codable {
    private(set) var farm: Int
    private(set) var id: String
    private(set) var server: String
    private(set) var secret: String
    private(set) var title: String
}
