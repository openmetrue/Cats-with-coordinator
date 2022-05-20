//
//  CoreDataAPI.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 14.04.2022.
//

import CoreData
import Combine

enum CDAPI {
    static private let coreDataStore = CoreDataStore(name: "Model")
}

extension CDAPI {
    static func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T> {
        //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //request.predicate = NSPredicate(format: "%K == %@", "isCompleted", NSNumber(value: false))
        return CoreDataFetchResultsPublisher(request: request, context: coreDataStore.viewContext)
    }
    static func publicher(save action: @escaping () -> Void) -> CoreDataSaveModelPublisher {
        return CoreDataSaveModelPublisher(action: action, context: coreDataStore.viewContext)
    }
    static func publicher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher {
        return CoreDataDeleteModelPublisher(delete: request, context: coreDataStore.viewContext)
    }
    static func createEntity<T: NSManagedObject>() -> T {
        return T(context: coreDataStore.viewContext)
    }
}
