//
//  Extension+UIImage.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 11..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

extension UIImage {

    enum Background {
        static let Cloudy = UIImage(named: "cloud")!
    }

    enum Icons {
        enum Weather {
            static let Pressure = UIImage(named: "pressure")!
            static let Humidity = UIImage(named: "humidity")!
            static let Wind = UIImage(named: "wind")!
            static let Clouds = UIImage(named: "clouds")!
            static let Rain = UIImage(named: "rain")!
            static let Snow = UIImage(named: "snow")!
        }

        enum Button {
            static let Back = UIImage(named: "back")!
            static let BackgroundSetting = UIImage(named: "backgroundSetting")!
        }

        enum SunInfo {
            static let Sunrise = UIImage(named: "sunrise")!
            static let Sunset = UIImage(named: "sunset")!
        }

        enum GPS {
            static let marker = UIImage(named: "marker")!
        }

    }

}
