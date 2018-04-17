//
//  RainyView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 15..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class RainyView: UIView {

    private let makeOverZero: Double = 0.01
    private let numberOfDrops: Int = 1000

    private var randomPositionX: Double {
        return randomValue(from: 0, to: UInt32(frame.width))
    }

    private var randomDropWidth: Double {
        return makeOverZero + drand48()
    }

    private var randomDropHeight: Double {
        return randomValue(from: 2, to: 20)
    }

    private var randomDuration: Double {
        return makeOverZero + drand48()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeRainyDrops()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeRainyDrops()
    }

    private func makeRainyDrops() {
        for _ in 0..<numberOfDrops {
            makeDrop()
        }
    }

    private func makeDrop() {
        let drop = CAGradientLayer()
        drop.frame = CGRect(
            x: randomPositionX,
            y: 0,
            width: randomDropWidth,
            height: randomDropHeight
        )
        drop.colors = [
            UIColor.clear.cgColor,
            UIColor(white: 1, alpha: 0.6).cgColor
        ]
        drop.locations = [0, 0.8]
        drop.cornerRadius = 5
        layer.addSublayer(drop)
        addRainingAnimation(layer: drop)
    }

    private func addRainingAnimation(layer: CAGradientLayer) {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = 0
        animation.toValue = frame.height
        animation.duration = randomDuration
        animation.repeatCount = .greatestFiniteMagnitude
        layer.add(animation, forKey: "animation")
    }

    private func randomValue(from minValue: UInt32, to maxValue: UInt32) -> Double {
        return Double(minValue + arc4random_uniform(maxValue - minValue))
    }
}
