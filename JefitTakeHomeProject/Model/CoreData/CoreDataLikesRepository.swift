//
//  CoreDataLikesRepository.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/4/22.
//

import Foundation
import CoreData

/// Performs CRUD operations with the Core Data stack.
class CoreDataLikesRepository {
    
    /// The managed object context of the Core Data stack.
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    /// Gets a Like object with the given business id from persistent store.
    /// - Parameter id: The id of the business.
    /// - Returns: Result containing either an error or a Like optional, nil if nonexistent.
    func get(id: String) -> Result<Like?, Error> {
        let fetchRequest = Like.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try managedObjectContext.fetch(fetchRequest)
            return .success(fetchResults.first)
        } catch {
            return .failure(error)
        }
    }
    
    /// Gets Like objects with the given business ids from persistent store.
    /// - Parameter ids: The ids of the businesses.
    /// - Returns: Result containing either an error or array of Like optionals, each nil if nonexistent.
    func get(ids: [String]) -> Result<[Like?], Error> {
        var likes = [Like?]()
        for i in 0..<ids.count {
            let result = get(id: ids[i])
            switch result {
            case let .failure(error): return .failure(error)
            case let .success(like):
                likes.append(like)
            }
        }
        return .success(likes)
    }
    
    /// Creates a Like object with business id, saving to persistent store.
    /// - Parameter id: The id of the business.
    /// - Returns: Result containing either an error or a Like optional, nil if already exists.
    func create(id: String) -> Result<Like?, Error> {
        var newLike: Like!
        switch get(id: id) {
        case let .failure(error): return .failure(error)
        case let .success(like):
            if like == nil {
                newLike = Like(context: managedObjectContext)
                newLike.id = id
            }
        }
        do {
            try managedObjectContext.save()
            return .success(newLike)
        } catch {
            managedObjectContext.rollback()
            return .failure(error)
        }
    }
    
    /// Deletes a Like object from persistent store.
    /// - Parameter like: The like to delete.
    /// - Returns: Optional error if save fails.
    func delete(like: Like) -> Error? {
        managedObjectContext.delete(like)
        do {
            try managedObjectContext.save()
            return nil
        } catch {
            managedObjectContext.rollback()
            return error
        }
    }
}
