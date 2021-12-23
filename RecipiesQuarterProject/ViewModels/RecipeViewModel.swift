//
//  RecipeViewModel.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 25.11.2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class RecipeViewModel {
    // Request manager
    private let requestManager: RequestManagerProtocol
    // Core data persistent controller
    private let persistentController: PersistentController!
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Recipe relay
    private let recipe = PublishRelay<Recipe>()
    // Recipe relay for core data saving
    private let recipeRelay = BehaviorRelay<Recipe?>(value: nil)
    // Recipe Stat relay
    private let recipeStatRelay = BehaviorRelay<[(name: String, image: UIImage?)]>(value: [])
    // Add favorite recipe button state subject
    private var addFavoriteRecipeButtonStateSubject: BehaviorSubject<Bool>!
    // Init
    init(requestManager: RequestManagerProtocol = RequestManager(),         persistentController: PersistentController = PersistentController(),
         id: Int) {
        
        self.requestManager = requestManager
        self.persistentController = persistentController
        
        requestRecipe(recipeId: id)
        let recipeData = fetchCoreDataObject(id: id)
        
        self.addFavoriteRecipeButtonStateSubject = BehaviorSubject<Bool>(value: recipeData)
    }
    
    func transform(_ input: Input) -> Output {
        handleAddRecipeButtonTap(input)
        
        return Output(recipeTitle: recipeTitleObserver,
                      recipeImage: recipeImageObserver,
                      recipeStat: recipeStatObserver,
                      recipeIngredients: recipeIngredients,
                      addFavoriteRecipeButtonState: addFavoriteRecipeButtonState)
    }
}
// MARK: - View Model Bindings
extension RecipeViewModel {
    struct Input {
        let addFavoriteRecipeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let recipeTitle: Driver<String>
        let recipeImage: Driver<String>
        let recipeStat: Driver<[(name: String, image: UIImage?)]>
        let recipeIngredients: Driver<[RecipeIngredients]>
        let addFavoriteRecipeButtonState: Driver<Bool>
    }
}
// MARK: - View Model Helpers
extension RecipeViewModel {
    private func handleAddRecipeButtonTap(_ input: Input) {
        let result = input.addFavoriteRecipeButtonTap.asObservable().map { _ -> Bool in
            
            guard let state = try? !self.addFavoriteRecipeButtonStateSubject.value() else {
                return false
            }
            
            return state
        }.share()
        
        result.subscribe(addFavoriteRecipeButtonStateSubject).disposed(by: disposeBag)
        
        handleRecipeInCoreData()
    }
    
    private func handleRecipeInCoreData() {
        let context = persistentController.mainContext
        
        let result = addFavoriteRecipeButtonState.asObservable()
            .observe(on: MainScheduler.instance)
            .map { $0 }
            .share()
        
        result.subscribe(onNext: { [unowned self] state in
            guard let value = recipeRelay.value else {
                return
            }
            
            if state {
                var ingredientsArray: [RecipeIngredientCoreData] = []
                
                for ingredient in value.ingredients {
                    let recipeIngredientCoreData = RecipeIngredientCoreData(context: context)
                    recipeIngredientCoreData.amount = ingredient.amount
                    recipeIngredientCoreData.unit = ingredient.unit
                    recipeIngredientCoreData.id = Int64(ingredient.id)
                    recipeIngredientCoreData.title = ingredient.name
                    recipeIngredientCoreData.image = ingredient.image

                    ingredientsArray.append(recipeIngredientCoreData)
                }
                
                let recipeCoreData = RecipeCoreData(context: context)
                recipeCoreData.id = Int64(value.id)
                recipeCoreData.title = value.title
                recipeCoreData.image = value.image
                recipeCoreData.vegan = value.vegan
                recipeCoreData.vegetarian = value.vegetarian
                recipeCoreData.veryHealthy = value.veryHealthy
                recipeCoreData.veryPopular = value.veryPopular
                recipeCoreData.dairyFree = value.dairyFree
                recipeCoreData.glutenFree = value.glutenFree
                recipeCoreData.ingredients = NSSet.init(array: ingredientsArray)
                
                self.persistentController.saveContext()
            } else {
                let fetchRequest: NSFetchRequest<RecipeCoreData>
                fetchRequest = RecipeCoreData.fetchRequest()
                
                fetchRequest.predicate = NSPredicate(format: "id == %i", value.id)
                
                if let result = try? persistentController.mainContext.fetch(fetchRequest).first {
                    persistentController.mainContext.delete(result)
                    persistentController.saveContext()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private var addFavoriteRecipeButtonState: Driver<Bool> {
        return addFavoriteRecipeButtonStateSubject.asDriver(onErrorJustReturn: false)
    }
    
    private var recipeTitleObserver: Driver<String> {
        return recipe.map{ $0.title }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeImageObserver: Driver<String> {
        return recipe.map { $0.image }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeStatObserver: Driver<[(name: String, image: UIImage?)]> {
        return recipeStatRelay.asDriver(onErrorJustReturn: [])
    }
    
    private var recipeIngredients: Driver<[RecipeIngredients]> {
        return recipe.map { $0.ingredients }.asDriver(onErrorJustReturn: [])
    }
}
// MARK: - View Model Requests
extension RecipeViewModel {
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
    
    func requestRecipe(recipeId: Int) {
        let parameters: [String: Any] = [
            "apiKey": Constants.apiKey
        ]
        
        let request = NetworkRequest(httpMethod: .get,
                                     endpoint: .singleRecipeInfo(recipeId: recipeId),
                                     parameters: parameters,
                                     headers: Constants.headers)
        
        let result = requestManager.requestSingleRecipe(request: request)
        
        result.subscribe(onNext: { [unowned self] value in
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
}
