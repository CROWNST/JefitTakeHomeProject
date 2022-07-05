//
//  CoreDataLikesRepository.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/4/22.
//

import Foundation
import CoreData

class CoreDataLikesRepository {
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func get(id: String) -> Result<Like?, Error> {
        // Create a fetch request for the associated NSManagedObjectContext type.
        let fetchRequest = Like.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        do {
            // Perform the fetch request
            let fetchResults = try managedObjectContext.fetch(fetchRequest)
            return .success(fetchResults.first)
        } catch {
            return .failure(error)
        }
    }
    
    func create(id: String) -> Result<Like?, Error> {
        var newLike: Like!
        switch get(id: id) {
        case let .failure(error):
            return .failure(error)
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
            managedObjectContext.reset()
            return .failure(error)
        }
    }
    
    func delete(like: Like) -> Error? {
        managedObjectContext.delete(like)
        do {
            try managedObjectContext.save()
            return nil
        } catch {
            managedObjectContext.reset()
            return error
        }
    }
}
