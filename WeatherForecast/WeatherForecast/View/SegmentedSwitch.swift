//
//  SegmentedSwitch.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 28..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class RoundedLayer: CALayer {

    override var bounds: CGRect {
        didSet { cornerRadius = bounds.height / 2.0 }
    }

}

struct SegmentedSwitchConfigure {
    var items: [String]
    var highlightedColor: UIColor
    var normalColor: UIColor
}

@IBDesignable
class SegmentedSwitch: UIView {

    @objc dynamic private var indicator = UIView()
    @IBInspectable var highlightedColor: UIColor = UIColor.black
    @IBInspectable var normalColor: UIColor = UIColor.white
    private var maskViewOfSelectedView = UIView()
    private var marginInset: CGFloat = 2.0
    private var itemWidth: CGFloat {
        return  frame.width / CGFloat(dataSource.count)
    }
    var dataSource: [String] = [] {
        didSet {
            initViews()
        }
    }

    lazy var unselectedView: SegmentedView = {
        return SegmentedView(
            frame: bounds,
            backgroundColor: highlightedColor,
            items: dataSource,
            textColor: normalColor
        )
    }()

    lazy var selectedView: SegmentedView = {
        return SegmentedView(
            frame: unselectedView.frame,
            backgroundColor: normalColor,
            items: dataSource,
            textColor: highlightedColor
        )
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override class var layerClass: AnyClass {
        return RoundedLayer.self
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(indicator.frame) {
            maskViewOfSelectedView.frame = indicator.frame
        }
    }

    private func initViews() {
        layer.cornerRadius = bounds.height / 2.0
        backgroundColor = UIColor.clear

        addSubview(unselectedView)

        let indicatorFrame = CGRect(
            x: marginInset,
            y: marginInset,
            width: itemWidth-2*marginInset,
            height: frame.height-2*marginInset
        )
        indicator.frame = indicatorFrame
        indicator.backgroundColor = normalColor
        indicator.layer.cornerRadius = bounds.height / 2.0
        addSubview(indicator)
        addObserver(self, forKeyPath: #keyPath(indicator.frame), options: .new, context: nil)

        maskViewOfSelectedView.frame = indicator.frame
        maskViewOfSelectedView.layer.cornerRadius = frame.height / 2.0
        maskViewOfSelectedView.backgroundColor = UIColor.black

        selectedView.layer.mask = maskViewOfSelectedView.layer
        addSubview(selectedView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }

    private func switchToItem(index: Int) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.indicator.frame.origin = CGPoint(
                    x: self.marginInset+CGFloat(index)*self.itemWidth,
                    y: self.marginInset
                )
            },
            completion: nil
        )
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let index = Int(floor(location.x / itemWidth))
        switchToItem(index: index)
    }

}
