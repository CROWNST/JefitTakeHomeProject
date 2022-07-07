//
//  BusinessesTableViewViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import Foundation

class BusinessesTableViewViewModel {
    
    let cityName: String
    var coreDataLikesRepository: CoreDataLikesRepository?
    var businessViewModels: [BusinessViewModel]? {
        didSet {
            reloadTableView?()
        }
    }
    var numCells: Int? {
        return businessViewModels?.count
    }
    
    var showError: ((String) -> ())?
    var reloadTableView: (() -> ())?
    var showLoading: (() -> ())?
    var hideLoading: (() -> ())?
    
    init(cityName: String, coreDataLikesRepository: CoreDataLikesRepository?) {
        self.cityName = cityName
        self.coreDataLikesRepository = coreDataLikesRepository
    }
    
    func getBusinessViewModel(at indexPath: IndexPath) -> BusinessViewModel? {
        return businessViewModels?[indexPath.row]
    }
    
    func initBusinessViewModels() {
        if coreDataLikesRepository != nil {
            showLoading?()
            YelpFusionClient.getBusinesses(city: cityName) { [weak self] in self?.handleGetBusinessesResponse(result: $0) }
        } else {
            showError?("Error with device storage.")
        }
    }
    
    private func handleGetBusinessesResponse(result: Result<BusinessResults, Error>) {
        hideLoading?()
        switch result {
        case let .failure(error):
            showError?(error.localizedDescription)
        case let .success(businessResults):
            setBusinessViewModels(from: businessResults)
        }
    }
    
    private func setBusinessViewModels(from businessResults: BusinessResults) {
        if coreDataLikesRepository != nil {
            let businesses = businessResults.businesses
            let businessIds = businesses.map { $0.id }
            let likesResult = self.coreDataLikesRepository!.get(ids: businessIds)
            switch likesResult {
            case let .failure(error):
                showError?(error.localizedDescription)
            case let .success(likes):
                let businessViewModelsArgs = zip(businesses, likes).map { (business: $0, like: $1) }
                businessViewModels = businessViewModelsArgs.map { BusinessViewModel(business: $0.business, like: $0.like) }
            }
        } else {
            showError?("Error with device storage.")
        }
    }
}
