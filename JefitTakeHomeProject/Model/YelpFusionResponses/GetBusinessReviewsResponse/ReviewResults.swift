//
//  ReviewResults.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/4/22.
//

import Foundation

/// Response type for Reviews endpoint.
struct ReviewResults: Codable {
    let reviews: [Review]
    let total: Int
}
