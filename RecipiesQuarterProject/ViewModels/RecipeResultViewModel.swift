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
struct RecipeResultViewModel {
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Request manager
    private let requestManger = RequestManager()
    // Fetched recipes
    private let recipes = BehaviorRelay<[RecipeResult]>(value: [])
    // Recipes observer for a view
    var recipesObserver: Observable<[RecipeResult]> {
        return recipes.asObservable()
    }
    
    // Search for recipes
    func searchRecipes(numberOfRecipes: Int, page: Int) {
        let result = requestManger.requestRecipes(request: NetworkRequest(httpMethod: .get, endpoint: .recipesSearch), key: Constants.apiKey, numberOfRecipes: numberOfRecipes, page: page)
        
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
