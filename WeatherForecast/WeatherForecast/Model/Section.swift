//
//  Section.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 13..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

enum Section: Int {
    case today, sunInfo
    var date: String {
        switch self {
        case .today: return "Today"
        case .sunInfo: return "Sun Info"
        }
    }
    static var numberOfSections: Int { return 2 }
}
