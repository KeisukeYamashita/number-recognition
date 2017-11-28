//
//  NumRecogEndpoint.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/11/28.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import Foundation

protocol NumRecogEndpoint: APIEndpoint {
    var path: String { get }
}

private let numRecogURL = URL(string: "http://localhost:3000/")!

extension NumRecogEndpoint {
    var url: URL {
        return URL(string: path, relativeTo: numRecogURL)!
    }
}
