//
//  Location.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/4/22.
//

import Foundation

struct Location: Codable {
    let displayAddress: [String]
    
    var address: String {
        return displayAddress.joined(separator: ", ")
    }
    
    private enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
    }
}
