//
//  UIViewController+Extensions.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/5/22.
//

import UIKit

extension UIViewController {
    
    /// Shows alert view with given message.
    /// - Parameter message: Message to display in alert view.
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
