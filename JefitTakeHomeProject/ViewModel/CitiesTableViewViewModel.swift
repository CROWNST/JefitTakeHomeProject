//
//  CityListViewModel.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import Foundation

struct CitiesTableViewViewModel {
    var cityViewModels = Cities.names.map { CityViewModel(name: $0) }
    var numCells: Int {
        return cityViewModels.count
    }
    
    func getCityName(at indexPath: IndexPath) -> String {
        return cityViewModels[indexPath.row].name
    }
}
