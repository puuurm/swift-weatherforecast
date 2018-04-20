//
//  Clock.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 29..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

class Clock {

    private var timer: Timer
    private let calendar = Calendar.current

    init() {
        timer = Timer()
    }

    func start() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.updateTime),
            userInfo: nil,
            repeats: true
        )
    }

    func stop() {
        timer.invalidate()
    }

    @objc private func updateTime() {
        print(timer.fireDate)
        let minute = calendar.component(.second, from: timer.fireDate)
        if minute == 0 {
            NotificationCenter.default.post(name: Notification.Name.DidUpdateTime, object: nil)
        }
    }

}
