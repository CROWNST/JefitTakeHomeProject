//
//  BusinessTableViewController.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import UIKit

/// Controls the businesses screen view.
class BusinessesTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    /// View model for the businesses table view.
    /// Is nil if Core Data stack failed to set up.
    var businessesTableViewViewModel: BusinessesTableViewViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    /// Sets UI-changing methods of the view model and initializes its business view models.
    private func setupViewModel() {
        if let businessesTableViewViewModel = businessesTableViewViewModel {
            businessesTableViewViewModel.reloadTableView = { [weak self] in
                DispatchQueue.main.async { self?.tableView.reloadData() }
            }
            businessesTableViewViewModel.showError = { [weak self] message in
                DispatchQueue.main.async { self?.showAlert(message) }
            }
            businessesTableViewViewModel.showLoading = { [weak self] show in
                DispatchQueue.main.async {
                    if show { self?.activityIndicatorView.startAnimating() } else { self?.activityIndicatorView.stopAnimating() } }
            }
            businessesTableViewViewModel.initBusinessViewModels()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessesTableViewViewModel?.numCells ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessesTableViewCell")!
        let businessViewModel = businessesTableViewViewModel!.getBusinessViewModel(at: indexPath)
        cell.textLabel?.text = businessViewModel!.business.name
        if businessViewModel!.like != nil {
            cell.imageView?.image = UIImage(systemName: "heart.fill")
        } else {
            cell.imageView?.image = UIImage(systemName: "heart")
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BusinessDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let businessViewModel = businessesTableViewViewModel!.getBusinessViewModel(at: indexPath)
                let coreDataLikesRepository = businessesTableViewViewModel!.coreDataLikesRepository
                // Init view model of BusinessDetailsViewController.
                vc.businessDetailViewViewModel = BusinessDetailViewViewModel(businessViewModel: businessViewModel!, coreDataLikesRepository: coreDataLikesRepository)
            }
        }
    }
}
