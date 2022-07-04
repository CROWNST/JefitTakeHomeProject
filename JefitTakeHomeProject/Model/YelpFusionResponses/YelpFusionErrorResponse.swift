//
//  YelpFusionErrorResponse.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/3/22.
//

import Foundation

struct YelpFusionErrorResponse: Codable {
    let error: [String:String]
}

extension YelpFusionErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error["description"]
    }
}
