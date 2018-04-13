//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 14..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    let backview = CloudyView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    func makeView(_ number: Int) {
        if number == 1 { return }
        backview.frame.size.height = frame.height
        backview.frame.size.width = frame.width
        addSubview(backview)
        backview.translatesAutoresizingMaskIntoConstraints = false
        backview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func start() {
        backview.moveClouds()
    }

    func stop() {
        backview.removeClouds()
    }
}
