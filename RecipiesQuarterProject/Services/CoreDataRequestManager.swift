//
//  CoreDataRequestManager.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 02.12.2021.
//

import Foundation
import RxSwift
import CoreData

protocol CoreDataRequestManagerProtocol {
    func fetchRecipes(context: NSManagedObjectContext) -> Observable<[RecipeCoreData]>
    func fetchRecipes(context: NSManagedObjectContext, title: String) -> Observable<[RecipeCoreData]>
    func fetchRecipe(context: NSManagedObjectContext, id: Int) -> Observable<RecipeCoreData>
}

class CoreDataRequestManager: CoreDataRequestManagerProtocol {
    func fetchRecipes(context: NSManagedObjectContext) -> Observable<[RecipeCoreData]> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<RecipeCoreData>
            fetchRequest = RecipeCoreData.fetchRequest()
            
            do {
                let result = try context.fetch(fetchRequest)
                observer.onNext(result)
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func fetchRecipes(context: NSManagedObjectContext, title: String) -> Observable<[RecipeCoreData]> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<RecipeCoreData>
            fetchRequest = RecipeCoreData.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(
                format: "title BEGINSWITH %@", "\(title)"
            )
            
            do {
                let result = try context.fetch(fetchRequest)
                observer.onNext(result)
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func fetchRecipe(context: NSManagedObjectContext, id: Int) -> Observable<RecipeCoreData> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<RecipeCoreData>
            fetchRequest = RecipeCoreData.fetchRequest()
//            fetchRequest.fetchLimit = 1
            
            fetchRequest.predicate = NSPredicate(
                format: "id LIKE %@", "\(id)"
            )
            
            do {
                if let result = try context.fetch(fetchRequest).first {
                    observer.onNext(result)
                }
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
