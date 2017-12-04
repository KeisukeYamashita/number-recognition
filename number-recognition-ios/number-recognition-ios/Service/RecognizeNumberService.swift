//
//  RecognizeNumberService.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/12/04.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import Foundation

struct RecognizeNumberService: NumRecogEndpoint {
    var path: String { return "/predict" }
    var method: HTTPMethod { return .POST }
    var body: [String : Any]? { return [ "data": data ] }
    typealias ResponseType = RecognizeNumberResult

    let data: [UInt8]

    init(data: [UInt8]) {
        self.data = data
    }
}

struct RecognizeNumberResult: JSONDecodable {
    let answer: String
    let confidence: String

    init(json: JSONObject) throws {
        self.answer = try json.get("answer")
        self.confidence = try json.get("confidence")
    }
}
