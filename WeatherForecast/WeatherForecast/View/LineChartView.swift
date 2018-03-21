//
//  LineChartView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 20..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

protocol LineChartDataSource: class {
    func baseData(lineChartView: LineChartView) -> [Float]
}

class LineChartView: UIView {

    weak var dataSource: LineChartDataSource?
    private var pointLayers = [CAShapeLayer]()
    private var lineLayer = CAShapeLayer()
    var cellIndex: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    private var data: [Float]? {
        return dataSource?.baseData(lineChartView: self)
    }
    private lazy var points: [CGPoint] = {
        return makeCoordinate()
    }()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.clear
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        pointLayers.removeAll()
        drawPoint(point: points[cellIndex], color: UIColor.white, radius: 6)
        drawLine(at: cellIndex)
    }

    private func drawPoint(point: CGPoint, color: UIColor, radius: CGFloat) {
        let circleLayer = CAShapeLayer()
        circleLayer.bounds = CGRect(x: 0, y: 0, width: radius, height: radius)
        circleLayer.path = UIBezierPath(ovalIn: circleLayer.bounds).cgPath
        circleLayer.fillColor = color.cgColor
        circleLayer.position = point
        self.layer.addSublayer(circleLayer)
    }

    private func drawLine(at index: Int) {
        let linePath = UIBezierPath()
        if index != 0 {
            let midLeftToCurrent = CGPoint(x: 0, y: (points[index-1].y + points[index].y) / CGFloat(2))
            linePath.move(to: midLeftToCurrent)
            linePath.addQuadCurve(to: points[index], controlPoint: controlPoint(for: (points[index], midLeftToCurrent)))
        } else {
            linePath.move(to: points[index])
        }
        let midCurrentToRight = CGPoint(x: frame.width, y: (points[index].y + points[index+1].y) / CGFloat(2))
        linePath.addQuadCurve(
            to: midCurrentToRight,
            controlPoint: controlPoint(
                for: (points[index], midCurrentToRight)
            )
        )

        lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = 1.0

        self.layer.addSublayer(lineLayer)
    }

    private func coordinateY(at index: Int) -> CGFloat {
        let data = self.data ?? []
        let max = data.max() ?? Float(frame.height)
        let min = data.min() ?? 0
        let cgFloatData = CGFloat(data[index])
        let cgFloatMax = CGFloat(max)
        let cgFloatMin = CGFloat(min)
        let value = (cgFloatMin - cgFloatData).magnitude /  ((cgFloatMax - (cgFloatMin-1)) / frame.height )
        return frame.height - value
    }

    private func makeCoordinate() -> [CGPoint] {
        let data = self.data ?? []
        var points = [CGPoint]()
        for i in 0..<data.count {
            points.append(CGPoint(x: self.center.x, y: coordinateY(at: i)))
        }
        return points
    }

    private func midPoint(for points: (CGPoint, CGPoint)) -> CGPoint {

        return CGPoint(x: (points.0.x + points.1.x) / 2, y: (points.0.y + points.1.y) / 2)
    }

    private func controlPoint(for points: (CGPoint, CGPoint)) -> CGPoint {

        var controlPoint = midPoint(for: points)
        let diffY = abs(points.1.y - controlPoint.y)

        if points.0.y < points.1.y {
            controlPoint.y += diffY
        } else if points.0.y > points.1.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}
