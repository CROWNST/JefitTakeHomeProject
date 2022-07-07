//
//  BusinessTableViewController.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import UIKit

class BusinessesTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var businessesTableViewViewModel: BusinessesTableViewViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupViewModel() {
        businessesTableViewViewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async { self?.tableView.reloadData() }
        }
        businessesTableViewViewModel.showError = { [weak self] message in
            DispatchQueue.main.async { self?.showAlert(message) }
        }
        businessesTableViewViewModel.showLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorView.startAnimating() }
        }
        businessesTableViewViewModel.hideLoading = { [weak self] in
            DispatchQueue.main.async { self?.activityIndicatorView.stopAnimating() }
        }
        businessesTableViewViewModel.initBusinessViewModels()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessesTableViewViewModel.numCells ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessesTableViewCell")!
        let businessViewModel = businessesTableViewViewModel.getBusinessViewModel(at: indexPath)
        cell.textLabel?.text = businessViewModel?.business.name
        if let businessViewModel = businessViewModel {
            if businessViewModel.like != nil {
                cell.imageView?.image = UIImage(systemName: "heart.fill")
            } else {
                cell.imageView?.image = UIImage(systemName: "heart")
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BusinessDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let businessViewModel = businessesTableViewViewModel.getBusinessViewModel(at: indexPath)
                let coreDataLikesRepository = businessesTableViewViewModel.coreDataLikesRepository
                vc.businessDetailViewViewModel = BusinessDetailViewViewModel(businessViewModel: businessViewModel!, coreDataLikesRepository: coreDataLikesRepository)
            }
        }
    }
}
