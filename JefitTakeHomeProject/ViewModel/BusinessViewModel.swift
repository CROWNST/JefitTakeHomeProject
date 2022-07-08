//
//  BusinessesTableViewCellViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import Foundation

/// View model for a business.
class BusinessViewModel {
    let business: Business
    /// Contains nil if business not liked.
    var like: Like?
    
    init(business: Business, like: Like?) {
        self.business = business
        self.like = like
    }
}
