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
            updateDrawingArea(minX: newPoint.x - 10, minY: nil, maxX: nil, maxY: nil)
        }
        if newPoint.x > area.maxX {
            updateDrawingArea(minX: nil, minY: nil, maxX: newPoint.x + 10, maxY: nil)
        }
        if newPoint.y < area.minY {
            updateDrawingArea(minX: nil, minY: newPoint.y - 10, maxX: nil, maxY: nil)
        }
        if newPoint.y > area.maxY {
            updateDrawingArea(minX: nil, minY: nil, maxX: nil, maxY: newPoint.y + 10)
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
        guard let area = drawingArea else { return nil }
        guard let croppedImage = getOriginalImage()?.crop(to: area) else { return nil }

        let width = min(20 * croppedImage.size.width / croppedImage.size.height, 20)
        let height = min(20 * croppedImage.size.height / croppedImage.size.width, 20)
        let scaledSize = CGSize(width: width, height: height)
        let scaledImage = croppedImage.scale(to: scaledSize)

        let size = CGSize(width: 28, height: 28)
        UIGraphicsBeginImageContext(size)
        let point = CGPoint(x: (28 - scaledImage.size.width) / 2, y: (28 - scaledImage.size.height) / 2)
        scaledImage.draw(at: point)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private func getOriginalImage() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let originalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return originalImage
    }

}
