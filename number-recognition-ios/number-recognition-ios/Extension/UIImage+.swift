//
//  UIImage+.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/12/04.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

extension UIImage {

    func crop(to rect: CGRect) -> UIImage? {
        guard let img = cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: img)
    }

    func scale(to size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height).integral
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .none
        self.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func scan() -> [Float]? {
        guard let cgImage = self.cgImage else { return nil }
        guard let pixelData = cgImage.dataProvider?.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel / 8

        var pixelsArray = [Float]()
        var position = 0
        for _ in 0..<Int(self.size.height) {
            for _ in 0..<Int(self.size.width) {
                let g = Float(data[position + 2])
                pixelsArray.append(255 - g > 100 ? 255.0 : 0.0)
                position += bytesPerPixel
            }
            if position % bytesPerRow != 0 {
                position += (bytesPerRow - (position % bytesPerRow))
            }
        }
        return pixelsArray
    }

}
