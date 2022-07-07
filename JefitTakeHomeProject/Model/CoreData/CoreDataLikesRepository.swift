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
