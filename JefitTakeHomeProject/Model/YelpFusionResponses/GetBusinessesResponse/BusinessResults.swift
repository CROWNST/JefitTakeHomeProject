//
//  BusinessResults.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/4/22.
//

import Foundation

/// Response type for Business Search endpoint.
struct BusinessResults: Codable {
    let businesses: [Business]
    let total: Int
}
