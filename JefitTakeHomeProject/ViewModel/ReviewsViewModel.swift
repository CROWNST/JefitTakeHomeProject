//
//  ReviewsViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/6/22.
//

import Foundation

/// View model for business reviews.
class ReviewsViewModel {
    
    let reviewResults: ReviewResults
    
    init(reviewResults: ReviewResults) {
        self.reviewResults = reviewResults
    }
    
    /// Provides text for the combined reviews.
    /// - Returns: The combined review text.
    func getReviewsText() -> String {
        var reviewText = ""
        reviewResults.reviews.forEach { reviewText.append("\n\($0.user.name)\n\($0.timeCreated)\nRating: \($0.rating)\n\($0.text)\n\n\n\n") }
        return reviewText
    }
}
