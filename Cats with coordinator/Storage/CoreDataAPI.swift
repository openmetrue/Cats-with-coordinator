//
//  CoreDataAPI.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 14.04.2022.
//

import CoreData
import Combine

protocol CoreDataService {
    func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T>
    func publicher(save action: @escaping () -> Void) -> CoreDataSaveModelPublisher
    func publicher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher
    func createEntity<T: NSManagedObject>() -> T
}

extension CoreDataStore: CoreDataService {
    public func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T> {
        //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //request.predicate = NSPredicate(format: "%K == %@", "isCompleted", NSNumber(value: false))
        return CoreDataFetchResultsPublisher(request: request, context: viewContext)
    }
    public func publicher(save action: @escaping () -> Void) -> CoreDataSaveModelPublisher {
        return CoreDataSaveModelPublisher(action: action, context: viewContext)
    }
    public func publicher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher {
        return CoreDataDeleteModelPublisher(delete: request, context: viewContext)
    }
    public func createEntity<T: NSManagedObject>() -> T {
        return T(context: viewContext)
    }
}
