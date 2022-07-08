//
//  AppDelegate.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/2/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack
    /// Sets up a CoreDataLikesRepository for interacting with Core Data.
    lazy var coreDataLikesRepository: CoreDataLikesRepository? = {
        var coreDataLikesRepository: CoreDataLikesRepository?
        let container = NSPersistentContainer(name: "JefitTakeHomeProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                let viewController = self.currentViewController()
                viewController?.showAlert(error.localizedDescription)
            } else {
                coreDataLikesRepository = CoreDataLikesRepository(managedObjectContext: container.viewContext)
            }
        })
        return coreDataLikesRepository
    }()
    
    /// Provides the current view controller.
    /// - Returns: The current view controller.
    private func currentViewController() -> UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
    }
}
