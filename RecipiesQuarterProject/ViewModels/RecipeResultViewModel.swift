//
//  RecipeResultViewModel.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 03.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

// View Model for recipe results model
class RecipeResultViewModel {
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Request manager
    private let requestManager: RequestManagerProtocol
    // Fetched recipes
    private let recipes = BehaviorRelay<[RecipeResult]>(value: [])
    // Recipes observer for a view
    var recipesObserver: Observable<[RecipeResult]> {
        return recipes.asObservable()
    }
    // Init
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    // Search for recipes
    func searchRecipes(numberOfRecipes: Int, page: Int) {
        
        let params: [String: Any] = [
            "apiKey": Constants.apiKey,
            "number": numberOfRecipes,
            "offset": page
        ]
        
        let request = NetworkRequest(httpMethod: .get,
                                     endpoint: .recipesSearch,
                                     parameters: params,
                                     headers: Constants.headers)
        
        let result = requestManager.requestRecipes(request: request)
        
        result.subscribe(onNext: { value in
            self.recipes.accept(value.results)
        }, onError: { error in
            _ = self.recipes.catch({ error in
                Observable.empty()
            })
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
