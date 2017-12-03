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

    var lineWidth: CGFloat = 10.0
    var lineColor: UIColor = .black

    var lines: [Line] = []
    var lastPoint: CGPoint?

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
    }

    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }

    private func getOriginalImage() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func getResizedImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 28, height: 28)
        UIGraphicsBeginImageContext(rect.size)
        getOriginalImage()?.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
