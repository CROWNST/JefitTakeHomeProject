//
//  BusinessDetailViewViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/6/22.
//

import Foundation

/// View model for the business detail view.
class BusinessDetailViewViewModel {
    
    let coreDataLikesRepository: CoreDataLikesRepository
    let businessViewModel: BusinessViewModel
    var reviewsViewModel: ReviewsViewModel? {
        didSet {
            setReviewsText?(reviewsViewModel!.getReviewsText())
        }
    }
    var businessImageData: Data? {
        didSet {
            showImage?(businessImageData)
        }
    }
    /// True if this business is liked by the user, false if not.
    var liked: Bool {
        return businessViewModel.like != nil
    }
    
    /// Methods to update the UI of BusinessDetailsViewController.
    var showError: ((String) -> ())?
    var showLoadingReviews: ((Bool) -> ())?
    var setReviewsText: ((String) -> ())?
    var showImage: ((Data?) -> ())?
    var showLike: ((Bool) -> ())?
    
    init(businessViewModel: BusinessViewModel, coreDataLikesRepository: CoreDataLikesRepository) {
        self.businessViewModel = businessViewModel
        self.coreDataLikesRepository = coreDataLikesRepository
    }
    
    /// Switches the like status of the business.
    func switchLike() {
        if liked {
            if let error = coreDataLikesRepository.delete(like: businessViewModel.like!) {
                showError?(error.localizedDescription)
            } else {
                businessViewModel.like = nil
                showLike?(false)
            }
        } else {
            let result = coreDataLikesRepository.create(id: businessViewModel.business.id)
            switch result {
            case let .failure(error): showError?(error.localizedDescription)
            case let .success(like):
                businessViewModel.like = like
                showLike?(true)
            }
        }
    }
    
    /// Initializes the reviews view model.
    func initReviewsViewModel() {
        showLoadingReviews?(true)
        YelpFusionClient.getBusinessReviews(id: businessViewModel.business.id) { [weak self] in self?.handleGetBusinessReviewsResponse(result: $0) }
    }
    
    /// Initializes the business image data.
    func initBusinessImage() {
        YelpFusionClient.getImage(imageUrl: businessViewModel.business.imageUrl) { [weak self] in
            self?.handleGetImageResponse(result: $0) }
    }
    
    /// Handler for network request to Reviews endpoint.
    /// - Parameter result: The network response.
    private func handleGetBusinessReviewsResponse(result: Result<ReviewResults, Error>) {
        showLoadingReviews?(false)
        switch result {
        case let .failure(error): showError?(error.localizedDescription)
        case let .success(reviewResults):
            reviewsViewModel = ReviewsViewModel(reviewResults: reviewResults)
        }
    }
    
    /// Handler for network request to get business image.
    /// - Parameter result: The network response.
    private func handleGetImageResponse(result: Result<Data, Error>) {
        switch result {
        case let .failure(error): showError?(error.localizedDescription)
        case let .success(data): businessImageData = data
        }
    }
}
