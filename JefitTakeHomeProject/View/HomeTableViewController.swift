//
//  ViewController.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/2/22.
//

import UIKit

/// Controls the home screen view.
class HomeTableViewController: UITableViewController {
    
    /// View model for the table view.
    let citiesTableViewViewModel = CitiesTableViewViewModel()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesTableViewViewModel.cityViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell")!
        let cityName = citiesTableViewViewModel.getCityName(at: indexPath)
        cell.textLabel?.text = cityName
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BusinessesTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let cityName = citiesTableViewViewModel.getCityName(at: indexPath)
                // An alert with an error will appear if Core Data stack fails to init.
                let coreDataLikesRepository = (UIApplication.shared.delegate as! AppDelegate).coreDataLikesRepository
                if coreDataLikesRepository != nil {
                    // Init view model of BusinessTableViewController.
                    vc.businessesTableViewViewModel = BusinessesTableViewViewModel(cityName: cityName!, coreDataLikesRepository: coreDataLikesRepository!)
                }
            }
        }
    }
}

