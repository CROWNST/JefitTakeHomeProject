//
//  BusinessDetailViewViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/6/22.
//

import Foundation

class BusinessDetailViewViewModel {
    
    let coreDataLikesRepository: CoreDataLikesRepository?
    var businessViewModel: BusinessViewModel
    var liked: Bool {
        return businessViewModel.like != nil
    }
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
    
    var showError: ((String) -> ())?
    var showLoadingReviews: ((Bool) -> ())?
    var setReviewsText: ((String) -> ())?
    var showImage: ((Data?) -> ())?
    var showLike: ((Bool) -> ())?
    
    init(businessViewModel: BusinessViewModel, coreDataLikesRepository: CoreDataLikesRepository?) {
        self.businessViewModel = businessViewModel
        self.coreDataLikesRepository = coreDataLikesRepository
    }
    
    func switchLike() {
        if coreDataLikesRepository != nil {
            if liked {
                if let error = coreDataLikesRepository!.delete(like: businessViewModel.like!) {
                    showError?(error.localizedDescription)
                } else {
                    businessViewModel.like = nil
                    showLike?(false)
                }
            } else {
                let result = coreDataLikesRepository!.create(id: businessViewModel.business.id)
                switch result {
                case let .failure(error): showError?(error.localizedDescription)
                case let .success(like):
                    businessViewModel.like = like
                    showLike?(true)
                }
            }
        } else {
            showError?("Error with device storage.")
        }
    }
    
    func initReviewsViewModel() {
        showLoadingReviews?(true)
        YelpFusionClient.getBusinessReviews(id: businessViewModel.business.id) { [weak self] in self?.handleGetBusinessReviewsResponse(result: $0) }
    }
    
    private func handleGetBusinessReviewsResponse(result: Result<ReviewResults, Error>) {
        showLoadingReviews?(false)
        switch result {
        case let .failure(error): showError?(error.localizedDescription)
        case let .success(reviewResults):
            reviewsViewModel = ReviewsViewModel(reviewResults: reviewResults)
        }
    }
    
    func initBusinessImage() {
        YelpFusionClient.getImage(imageUrl: businessViewModel.business.imageUrl) { [weak self] in
            self?.handleGetImageResponse(result: $0) }
    }
    
    private func handleGetImageResponse(result: Result<Data, Error>) {
        switch result {
        case let .failure(error): showError?(error.localizedDescription)
        case let .success(data): businessImageData = data
        }
    }
}
