//
//  Review.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/4/22.
//

import Foundation

struct Review: Codable {
    let rating: Int
    let user: User
    let text: String
    let timeCreated: String
    
    private enum CodingKeys: String, CodingKey {
        case rating
        case user
        case text
        case timeCreated = "time_created"
    }
}
