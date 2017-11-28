//
//  GetStatusService.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/11/28.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import Foundation

struct GetStatusService: NumRecogEndpoint {
    var path: String { return "/status" }
    typealias ResponseType = GetStatusResult
}

struct GetStatusResult: JSONDecodable {
    let status: TrainStatus

    init(json: JSONObject) throws {
        let status: String = try json.get("train_status")
        self.status = TrainStatus.from(status)
    }
}

enum TrainStatus: String {
    case notTrained = "学習していません"
    case nowTraining = "学習中です..."
    case wellTrained = "学習済みです"

    static func from(_ str: String) -> TrainStatus {
        switch str {
        case "not trained": return .notTrained
        case "now training": return .nowTraining
        case "well trained": return .wellTrained
        default: return .notTrained
        }
    }
}
