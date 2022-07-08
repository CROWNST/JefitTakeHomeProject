//
//  BusinessDetailsViewController.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/6/22.
//

import UIKit

/// Controls the business details screen view.
class BusinessDetailsViewController: UIViewController {

    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    /// View model for the business detail view.
    var businessDetailViewViewModel: BusinessDetailViewViewModel!
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        businessDetailViewViewModel.switchLike()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBusinessDetailViewViewModel()
        setBusinessInfo()
        showLike(show: businessDetailViewViewModel.liked)
    }
    
    /// Sets UI-changing methods of the view model and initializes its reviews view model and image data.
    private func setupBusinessDetailViewViewModel() {
        businessDetailViewViewModel.showError = { [weak self] message in
            DispatchQueue.main.async { self?.showAlert(message) }
        }
        businessDetailViewViewModel.showLoadingReviews = { [weak self] show in
            DispatchQueue.main.async {
                if show { self?.activityIndicatorView.startAnimating() } else { self?.activityIndicatorView.stopAnimating() }
            }
        }
        businessDetailViewViewModel.setReviewsText = { [weak self] reviews in
            DispatchQueue.main.async {
                self?.reviewsLabel.text = "REVIEWS:\(reviews)"
            }
        }
        businessDetailViewViewModel.showImage = { [weak self] data in
            DispatchQueue.main.async {
                if let data = data { self?.imageView.image = UIImage(data: data) } else { self?.imageView.image = UIImage(named: "shop-placeholder") }
            }
        }
        businessDetailViewViewModel.showLike = { [weak self] show in
            DispatchQueue.main.async {
                self?.showLike(show: show)
            }
        }
        businessDetailViewViewModel.initReviewsViewModel()
        businessDetailViewViewModel.initBusinessImage()
    }
    
    /// Updates the UI to include business information.
    private func setBusinessInfo() {
        let business = businessDetailViewViewModel.businessViewModel.business
        nameLabel.text = business.name
        addressLabel.text = business.address
        categoryLabel.text = business.categoryList
        ratingLabel.text = "Rating: \(business.rating)"
    }
    
    /// Updates the UI with updated like status.
    /// - Parameter show: Whether to like the business or not.
    private func showLike(show: Bool) {
        if show { likeButton.image = UIImage(systemName: "heart.fill") } else { likeButton.image = UIImage(systemName: "heart") }
    }
}
