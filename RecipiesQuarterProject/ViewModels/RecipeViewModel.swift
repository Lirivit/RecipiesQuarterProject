//
//  RecipeViewModel.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 25.11.2021.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class RecipeViewModel {
    // Request manager
    private let requestManager: RequestManagerProtocol
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Recipe relay
    private let recipe = PublishRelay<Recipe>()
    // Recipe Stat relay
    private let recipeStatRelay = BehaviorRelay<[(name: String, image: UIImage?)]>(value: [])
    // Init
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output(recipeTitle: recipeTitleObserver,
                      recipeImage: recipeImageObserver,
                      recipeSummary: recipeSummaryObserver,
                      recipeStat: recipeStatObserver)
    }
}
// MARK: - View Model Bindings
extension RecipeViewModel {
    struct Input {
    }
    
    struct Output {
        let recipeTitle: Driver<String>
        let recipeImage: Driver<String>
        let recipeSummary: Driver<String>
        let recipeStat: Driver<[(name: String, image: UIImage?)]>
    }
}
// MARK: - View Model Helpers
extension RecipeViewModel {
    private var recipeTitleObserver: Driver<String> {
        return recipe.map{ $0.title }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeImageObserver: Driver<String> {
        return recipe.map { $0.image }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeSummaryObserver: Driver<String> {
        return recipe.map { $0.summary }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeStatObserver: Driver<[(name: String, image: UIImage?)]> {
        return recipeStatRelay.asDriver(onErrorJustReturn: [])
    }
}
// MARK: - View Model Requests
extension RecipeViewModel {
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
        }, onError: { [unowned self] error in
            _ = self.recipe.catch { error in
                Observable.empty()
            }
        }).disposed(by: disposeBag)
    }
}
