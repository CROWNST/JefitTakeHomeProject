//
//  BusinessesTableViewCellViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import Foundation

class BusinessViewModel {
    let business: Business
    var like: Like?
    
    init(business: Business, like: Like?) {
        self.business = business
        self.like = like
    }
}
