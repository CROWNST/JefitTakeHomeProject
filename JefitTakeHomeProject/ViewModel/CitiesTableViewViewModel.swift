//
//  CityListViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import Foundation

/// View model for the table view of cities.
struct CitiesTableViewViewModel {

    /// Contains city view models.
    let cityViewModels = Cities.names.map { CityViewModel(name: $0) }
    
    /// Returns the name of a city at the index.
    /// - Parameter indexPath: The selected table view index path.
    /// - Returns: The city name or nil if index out of bounds.
    func getCityName(at indexPath: IndexPath) -> String? {
        guard indexPath.row >= 0 && indexPath.row < cityViewModels.count else {
            return nil
        }
        return cityViewModels[indexPath.row].name
    }
}
