//
//  UIImage+.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/12/04.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

extension UIImage {

    func getPixels() -> [UInt8] {
        guard let image = cgImage else { return [] }
        guard let data = image.dataProvider?.data else { return [] }
        let length = CFDataGetLength(data)
        var rawData = [UInt8](repeating: 0, count: length)
        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
        return rawData
    }

}
