//
//  FavoriteRecipeViewModel.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 11.12.2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import Kingfisher
import Alamofire

class FavoriteRecipeViewModel {
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Core data request manager
    private let coreRequestManager: CoreDataRequestManagerProtocol
    // Core data persistent controller
    private let persistentController: PersistentController
    // Add favorite recipe button state subject
    private var addFavoriteRecipeButtonStateSubject: BehaviorSubject<Bool>!
    // Recipe Stat relay
    private let recipeStatRelay = BehaviorRelay<[(name: String, image: UIImage?)]>(value: [])
    // Recipe relay for core data saving
    private let recipeRelay = BehaviorRelay<RecipeCoreData?>(value: nil)
    // Recipe relay
    private let recipe = PublishRelay<RecipeCoreData>()
    
    init(requestManager: CoreDataRequestManagerProtocol = CoreDataRequestManager(),
         persistentController: PersistentController = PersistentController(),
         id: Int) {
        
        self.coreRequestManager = requestManager
        self.persistentController = persistentController
        
        let recipeData = fetchCoreDataObject(id: id)
        
        self.addFavoriteRecipeButtonStateSubject = BehaviorSubject<Bool>(value: recipeData)
        fetchRecipe(id: id)
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output(recipeTitle: recipeTitleObserver,
                      recipeImage: recipeImageObserver,
                      recipeStat: recipeStatObserver,
                      recipeIngredients: recipeIngredientsObserver)
    }
}
// MARK: - View Model Bindings
extension FavoriteRecipeViewModel {
    struct Input { }
    
    struct Output {
        let recipeTitle: Driver<String>
        let recipeImage: Driver<String>
        let recipeStat: Driver<[(name: String, image: UIImage?)]>
        let recipeIngredients: Driver<[RecipeIngredientCoreData]>
    }
}
// MARK: - View Model Helpers
extension FavoriteRecipeViewModel {
    private var recipeTitleObserver: Driver<String> {
        return recipeRelay.map{ $0?.title ?? "" }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeImageObserver: Driver<String> {
        return recipeRelay.map { $0?.image ?? "" }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeStatObserver: Driver<[(name: String, image: UIImage?)]> {
        return recipeStatRelay.asDriver(onErrorJustReturn: [])
    }
    
    private var recipeIngredientsObserver: Driver<[RecipeIngredientCoreData]> {
        return recipeRelay.map({ value -> [RecipeIngredientCoreData] in
            guard let ingredients = value?.ingredients?.allObjects as? [RecipeIngredientCoreData] else {
                print("error with ingredients converting")
                return []
            }
            
            return ingredients
        }).asDriver(onErrorJustReturn: [])
    }
}
// MARK: - View Model Requests
extension FavoriteRecipeViewModel {
    private func fetchRecipe(id: Int) {
        let context = persistentController.mainContext
        
        let result = coreRequestManager.fetchRecipe(context: context, id: id)
        
        result.subscribe(onNext: { value in
            var temp: [(name: String, image: UIImage?)] = []
            
            
            if value.vegan {
                temp.append((name: "vegan", image: UIImage(named: "VeganImage")))
            }
            
            if value.vegetarian {
                temp.append((name: "vegetarian", image: UIImage(named: "VegetarianImage")))
            }
            
            if value.veryHealthy {
                temp.append((name: "healthy", image: UIImage(named: "HealthyImage")))
            }
            
            if value.veryPopular {
                temp.append((name: "popular", image: UIImage(named: "PopularImage")))
            }
            
            if value.dairyFree {
                temp.append((name: "dairy \nfree", image: UIImage(named: "DairyFreeImage")))
            }
            
            if value.glutenFree {
                temp.append((name: "gluten \nfree", image: UIImage(named: "GlutenFreeImage")))
            }
            
            self.recipeStatRelay.accept(temp)
            self.recipe.accept(value)
            self.recipeRelay.accept(value)
        }, onError: { [unowned self] error in
            _ = self.recipe.catch { error in
                Observable.empty()
            }
        }).disposed(by: disposeBag)
    }
    
    private func fetchCoreDataObject(id: Int) -> Bool {
        let managedContext = persistentController.mainContext
        
        let fetchRequest: NSFetchRequest<RecipeCoreData>
        fetchRequest = RecipeCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 0 {
                return false
            } else {
                return true
            }
        } catch {
            print(error)
            return false
        }
    }
}
