//
//  PersistentController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 07.12.2021.
//

import Foundation
import CoreData

class PersistentController {
    private static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipiesQuarterProject")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return PersistentController.container.viewContext
    }()
    
    init(inMemory: Bool = false) {
        
    }
    
    func saveContext() {
        saveContext(context: mainContext)
    }
    
    func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            debugPrint("Save context error: \(error)")
        }
    }
}
