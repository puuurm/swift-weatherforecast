//
//  Extenstion+Font.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 19..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

extension UIFont {
    class func georgia(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Georgia", size: fontSize) ?? UIFont()
    }
}

extension UIColor {

    class func skyBlue(alpha: CGFloat = 1) -> UIColor {
        return UIColor.rgb(red: 117, green: 217, blue: 242, alpha: alpha)
    }

    class func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/256, green: green/256, blue: blue/256, alpha: alpha)
    }
}

struct StringAttribute {

    static func textWithBorder(fontSize: CGFloat) -> [NSAttributedStringKey: Any] {
        return [
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.strokeWidth: -1,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize, weight: .regular)
            ] as [NSAttributedStringKey : Any]
    }
}
