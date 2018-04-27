//
//  SegmentedView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 28..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SegmentedView: UIView {

    init(frame: CGRect, backgroundColor: UIColor, items: [String], textColor: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = backgroundColor
        initView(items: items, textColor: textColor)
    }

    override class var layerClass: AnyClass {
        return RoundedLayer.self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func initView(items: [String], textColor: UIColor) {
        let count = items.count
        let eachItemWidth = frame.width / CGFloat(count)
        let textColor = textColor
        for index in 0..<count {
            let text = items[index]
            let label = createItemLabel(at: index, width: eachItemWidth, text: text, textColor: textColor)
            addSubview(label)
        }
    }

    private func createItemLabel(at index: Int, width: CGFloat, text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.frame = CGRect(x: width*CGFloat(index), y: 0, width: width, height: frame.height)
        label.text = text
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }

}
