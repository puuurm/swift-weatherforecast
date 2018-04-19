//
//  PhotoList.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 18..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

struct FlickerJSON: Codable {

    private(set) var photos: Photos
    private(set) var stat: String

    func photo(at index: Int) -> Photo? {
        return photos.photo.count > index ? photos.photo[index] : nil
    }
}
