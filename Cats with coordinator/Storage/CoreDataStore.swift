//
//  CoreDataStore.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import CoreData
import Combine

struct CoreDataStore {
    
    var container: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init(name: String) {
        self.container = NSPersistentContainer(name: name)
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
