//
//  Business.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/3/22.
//

import Foundation

/// Contains data for one business.
struct Business: Codable {
    let id: String
    let name: String
    let imageUrl: String
    let categories: [Category]
    let rating: Double
    let location: Location
    
    /// Displayable address.
    var address: String {
        return location.address
    }
    /// Categories as a formatted list.
    var categoryList: String {
        return categories.map { $0.title }.joined(separator: ", ")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case categories
        case rating
        case location
    }
}


