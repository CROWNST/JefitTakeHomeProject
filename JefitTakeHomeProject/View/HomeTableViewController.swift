//
//  ViewController.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/2/22.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var citiesTableViewViewModel = CitiesTableViewViewModel()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesTableViewViewModel.numCells
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
                let coreDataLikesRepository = (UIApplication.shared.delegate as! AppDelegate).coreDataLikesRepository
                vc.businessesTableViewViewModel = BusinessesTableViewViewModel(cityName: cityName, coreDataLikesRepository: coreDataLikesRepository)
            }
        }
    }
}

