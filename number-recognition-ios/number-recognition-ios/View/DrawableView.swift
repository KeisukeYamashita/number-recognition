//
//  DrawableView.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/11/28.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class Line {
    let start: CGPoint
    let end: CGPoint

    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}

class DrawableView: UIView {

    var lineWidth: CGFloat = 20.0
    var lineColor: UIColor = .black

    private var lines: [Line] = []
    private var lastPoint: CGPoint?

    private var drawingArea: CGRect?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        path.lineCapStyle = .round
        for line in lines {
            path.move(to: line.start)
            path.addLine(to: line.end)
        }
        path.lineWidth = lineWidth
        lineColor.set()
        path.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first?.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let lastPoint = lastPoint else { return }
        guard let newPoint = touches.first?.location(in: self) else { return }
        let newLine = Line(start: lastPoint, end: newPoint)
        lines.append(newLine)
        self.lastPoint = newPoint
        setNeedsDisplay()

        if drawingArea == nil {
            let x = newPoint.x - lineWidth
            let y = newPoint.y - lineWidth
            drawingArea = CGRect(x: x, y: y, width: lineWidth, height: lineWidth)
        }
        stretchDrawingArea(to: newPoint)
    }

    private func stretchDrawingArea(to newPoint: CGPoint) {
        guard let area = drawingArea else { return }
        if newPoint.x < area.minX {
            updateDrawingArea(minX: newPoint.x, minY: nil, maxX: nil, maxY: nil)
        }
        if newPoint.x > area.maxX {
            updateDrawingArea(minX: nil, minY: nil, maxX: newPoint.x, maxY: nil)
        }
        if newPoint.y < area.minY {
            updateDrawingArea(minX: nil, minY: newPoint.y, maxX: nil, maxY: nil)
        }
        if newPoint.y > area.maxY {
            updateDrawingArea(minX: nil, minY: nil, maxX: nil, maxY: newPoint.y)
        }
    }

    private func updateDrawingArea(minX: CGFloat?, minY: CGFloat?, maxX: CGFloat?, maxY: CGFloat?) {
        guard let area = drawingArea else { return }
        let x = minX ?? area.minX
        let y = minY ?? area.minY
        let width = maxX ?? area.maxX - x
        let height = maxY ?? area.maxY - y
        drawingArea = CGRect(x: x, y: y, width: width, height: height)
    }

    func clear() {
        lines.removeAll()
        setNeedsDisplay()
        drawingArea = nil
    }

    func getImage() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let area = drawingArea else { return nil }
        return image?.crop(to: area)
    }

}
