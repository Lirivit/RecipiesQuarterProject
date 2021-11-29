//
//  SearchRecipesViewModel.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 20.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class SearchRecipesViewModel {
    // Request manager
    private let requestManager: RequestManagerProtocol
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Recipes subject
    private let recipes = BehaviorRelay<[RecipeResult]>(value: [])
    // Recipes total result
    private let recipesTotalResults = PublishSubject<Int>()
    // Recipes offset
    private let recipesOffset = BehaviorRelay<Int>(value: 0)
    // Search bar text subject for a view
    private let searchBarSubject = PublishSubject<String>()
    // Search bar relay
    private let searchBarRelay = BehaviorRelay<String>(value: "")
    // Recipe id
    private let recipeSubject = PublishSubject<Int>()
    
    // Init
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func transform(_ input: Input) -> Output {
        bindSearchBarText(input)
        handleTableViewScroll(input)
        handleTableViewSelection(input)
        
        return Output(recipesObserver: recipesObserver, recipeObserver: recipeObserver)
    }
}
// MARK: - View Model Bindings
extension SearchRecipesViewModel {
    struct Input {
        let searchText: Observable<String>
        let tableViewPagination: ControlEvent<WillDisplayCellEvent>
        let tableViewSelectedItem: ControlEvent<RecipeResult>
    }
    
    struct Output {
        let recipesObserver: Driver<[RecipeResult]>
        let recipeObserver: Driver<Int>
    }
}
// MARK: - View Model Helpers
extension SearchRecipesViewModel {
    private var recipesObserver: Driver<[RecipeResult]> {
        return recipes.asDriver(onErrorJustReturn: []) // TODO: - Remove on just error
    }
    
    private var searchTextObserver: Driver<String> {
        return searchBarSubject.asDriver(onErrorJustReturn: "") // TODO: - Remove on just error
    }
    
    private var recipesTotalResultsObserver: Observable<Int> {
        return recipesTotalResults.asObservable()
    }
    
    private var recipeObserver: Driver<Int> {
        return recipeSubject.asDriver(onErrorJustReturn: 0)
    }
    
    private func handleTableViewScroll(_ input: Input) {
        input.tableViewPagination.asDriver().drive(onNext: { [unowned self] cell, indexPath in
            if indexPath.row == recipesOffset.value + 19 {
                recipesOffset.accept(recipesOffset.value + 20)
                searchRecipes(query: self.searchBarRelay.value)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindSearchBarText(_ input: Input) {
        input.searchText.subscribe(searchBarSubject).disposed(by: disposeBag)
        handleSearchBarInput()
    }
    
    private func handleTableViewSelection(_ input: Input) {
        let result = input.tableViewSelectedItem.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { $0.id }
            .share()
        
        result.subscribe(recipeSubject).disposed(by: disposeBag)
    }
    
    private func handleSearchBarInput() {
        searchTextObserver.drive(onNext: { [unowned self] value in
            if !value.isEmpty {
                self.recipesOffset.accept(0)
                self.searchBarRelay.accept(value)
                self.searchRecipes(query: value)
            } else {
                self.recipesOffset.accept(0)
                self.searchBarRelay.accept("")
                self.searchRecipes(query: "")
            }
        }).disposed(by: disposeBag)
    }
}
// MARK: - View Model Requests
extension SearchRecipesViewModel {
    func searchRecipes(query: String) {
        let params: [String: Any] = [
            "apiKey": Constants.apiKey,
            "query": query,
            "number": 20,
            "offset": recipesOffset.value
        ]
        
        let request = NetworkRequest(httpMethod: .get,
                                     endpoint: .recipesSearch,
                                     parameters: params,
                                     headers: Constants.headers)
        
        let result = requestManager.requestRecipes(request: request)
        
        result.subscribe(onNext: { [unowned self] value in
            if self.recipesOffset.value == 0 {
                self.recipes.accept(value.results)
                self.recipesTotalResults.onNext(value.totalResults)
            } else {
                self.recipes.accept(recipes.value + value.results)
                self.recipesTotalResults.onNext(value.totalResults)
            }
        }, onError: { [unowned self] error in
            _ = self.recipes.catch({ error in
                Observable.empty()
            })
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
