//
//  BusinessesTableViewViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import Foundation

/// View model for the table view of businesses.
class BusinessesTableViewViewModel {
    
    let cityName: String
    let coreDataLikesRepository: CoreDataLikesRepository
    var businessViewModels = [BusinessViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    var numCells: Int {
        return businessViewModels.count
    }
    
    /// Methods to update the UI of BusinessesTableViewController.
    var showError: ((String) -> ())?
    var reloadTableView: (() -> ())?
    var showLoading: ((Bool) -> ())?
    
    init(cityName: String, coreDataLikesRepository: CoreDataLikesRepository) {
        self.cityName = cityName
        self.coreDataLikesRepository = coreDataLikesRepository
    }
    
    /// Gets the business view model at table view index path.
    /// - Parameter indexPath: The table view index path.
    /// - Returns: The business view model at the index or nil if invalid index.
    func getBusinessViewModel(at indexPath: IndexPath) -> BusinessViewModel? {
        guard indexPath.row >= 0 && indexPath.row < numCells else {
            return nil
        }
        return businessViewModels[indexPath.row]
    }
    
    /// Starts initialization of business view model array.
    func initBusinessViewModels() {
        showLoading?(true)
        YelpFusionClient.getBusinesses(city: cityName) { [weak self] in self?.handleGetBusinessesResponse(result: $0) }
    }
    
    /// Handler for getting business data from Business Search endpoint.
    /// - Parameter result: Result of the network request.
    private func handleGetBusinessesResponse(result: Result<BusinessResults, Error>) {
        showLoading?(false)
        switch result {
        case let .failure(error):
            showError?(error.localizedDescription)
        case let .success(businessResults):
            setBusinessViewModels(from: businessResults)
        }
    }
    
    /// Helper method to initialize to initialize the array of business view models.
    /// - Parameter businessResults: Obtained from network request to Business Search endpoint.
    private func setBusinessViewModels(from businessResults: BusinessResults) {
        let businesses = businessResults.businesses
        let businessIds = businesses.map { $0.id }
        // Obtain Like objects for given business ids from persistent store.
        let likesResult = self.coreDataLikesRepository.get(ids: businessIds)
        switch likesResult {
        case let .failure(error):
            showError?(error.localizedDescription)
        case let .success(likes):
            // Arguments as array of tuples for initializing business view models.
            let businessViewModelsArgs = zip(businesses, likes).map { (business: $0, like: $1) }
            businessViewModels = businessViewModelsArgs.map { BusinessViewModel(business: $0.business, like: $0.like) }
        }
    }
}
