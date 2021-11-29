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
    // Search bar text subject for a view
    private let searchBarSubject = PublishSubject<String>()
    // Search bar tap subject
    private let searchTapSubject = PublishSubject<Void>()
    // Init
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func transform(_ input: Input) -> Output {
        bindTextToSearchBarSubject(input)
        handleSearchTap(input)
        
        return Output(searchBarText: searchBarText,
                      collectionViewObserver: recipesObserver,
                      searchTapped: searchTapObserver)
    }
    
}

// MARK: - View Model Bindings
extension RecipeResultViewModel {
    struct Input {
        let searchBarText: Observable<String>
        let searchTapped: ControlEvent<Void>
    }
    
    struct Output {
        let searchBarText: Driver<String>
        let collectionViewObserver: Driver<[RecipeResult]>
        let searchTapped: Driver<Void>
    }
}

// MARK: - View Model Helpers
extension RecipeResultViewModel {
    private var searchBarText: Driver<String> {
        searchBarSubject.asDriver(onErrorJustReturn: "") // TODO: - Change to do on error
    }
    
    private var searchTapObserver: Driver<Void> {
        searchTapSubject.asDriver(onErrorDriveWith: Driver.never())
    }
    
    private var recipesObserver: Driver<[RecipeResult]> {
        return recipes.asDriver(onErrorJustReturn: []) // TODO: - Change to do on error
    }
    
    private func bindTextToSearchBarSubject(_ input: Input) {
        input.searchBarText.subscribe(searchBarSubject).disposed(by: disposeBag)
    }
    
    private func handleSearchTap(_ input: Input) {
        let result = input.searchTapped.withLatestFrom(Observable.just(input.searchBarText))
            .share()
        
        result.map{ _ in }.subscribe(searchTapSubject).disposed(by: disposeBag)
    }
}

// MARK: - View Model Requests
extension RecipeResultViewModel {
    // Search for recipes
    func searchRecipes(page: Int) {
        let params: [String: Any] = [
            "apiKey": Constants.apiKey,
            "number": 10,
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
