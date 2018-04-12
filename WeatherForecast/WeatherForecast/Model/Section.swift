//
//  Section.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 13..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

enum Section: Int {
    case main, today, detail, sunInfo
    var date: String {
        switch self {
        case .main: return ""
        case .today: return "Today"
        case .detail: return "Detail Weather"
        case .sunInfo: return "Sun Info"
        }
    }
    static var numberOfSections: Int { return 4 }
}
