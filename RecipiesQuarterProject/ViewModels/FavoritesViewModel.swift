//
//  FavoritesViewModel.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 01.12.2021.
//

import Foundation
import RxCocoa
import RxSwift

class FavoritesViewModel {
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Core data request manager
    private let coreDataRequestManager: CoreDataRequestManagerProtocol
    // Core data persistent controller
    private let persistentController: PersistentController
    // Recipes view model
    private let recipes = BehaviorRelay<[RecipeCoreData]>(value: [])
    // Recipe id subject
    private let recipeIdSubject = PublishSubject<Int>()
    // Search bar text subject for a view
    private let searchBarSubject = PublishSubject<String>()
    // Search bar done button action subject
    private let searchBarDoneSubject = PublishSubject<Void>()
    // Init
    init(requestManager: CoreDataRequestManagerProtocol = CoreDataRequestManager(),
         persistentController: PersistentController = PersistentController()) {
        self.coreDataRequestManager = requestManager
        self.persistentController = persistentController
    }
    
    func transform(_ input: Input) -> Output {
        bindSearchBarText(input)
        handleTableViewSelection(input)
        
        return Output(recipes: recipesDriver,
                      recipeIdObserver: recipeIdSubjectObserver,
                      searchBarDoneButtonObserver: searchBarDoneButtonObserver)
    }
}
// MARK: - View Model Bindings
extension FavoritesViewModel {
    struct Input {
        let searchText: Observable<String>
        let tableViewCellSelection: ControlEvent<RecipeCoreData>
        let searchBarDoneButton: ControlEvent<Void>
    }
    
    struct Output {
        let recipes: Driver<[RecipeCoreData]>
        let recipeIdObserver: Driver<Int>
        let searchBarDoneButtonObserver: Driver<Void>
    }
}
// MARK: - View Model Helpers
extension FavoritesViewModel {
    private var recipesDriver: Driver<[RecipeCoreData]> {
        return recipes.asDriver(onErrorJustReturn: [])
    }
    
    private var recipeIdSubjectObserver: Driver<Int> {
        return recipeIdSubject.asDriver(onErrorJustReturn: 0)
    }
    
    private var searchTextObserver: Driver<String> {
        return searchBarSubject.asDriver(onErrorJustReturn: "") // TODO: - Remove on just error
    }
    
    private var searchBarDoneButtonObserver: Driver<Void> {
        return searchBarDoneSubject.asDriver(onErrorJustReturn: ())
    }
    
    private func handleTableViewSelection(_ input: Input) {
        let result = input.tableViewCellSelection.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Int($0.id) }
            .share()
        
        result.subscribe(recipeIdSubject).disposed(by: disposeBag)
    }
    
    private func bindSearchBarText(_ input: Input) {
        input.searchText.subscribe(searchBarSubject).disposed(by: disposeBag)
        input.searchBarDoneButton.subscribe(searchBarDoneSubject).disposed(by: disposeBag)
        handleSearchBarInput()
    }
    
    private func handleSearchBarInput() {
        searchTextObserver.drive(onNext: { [unowned self] value in
            if !value.isEmpty {
                self.fetchRecipes(title: value)
            } else {
                self.fetchRecipes()
            }
        }).disposed(by: disposeBag)
    }
}
// MARK: - View Model Fetch Requests
extension FavoritesViewModel {
    func fetchRecipes() {
        let context = persistentController.mainContext
        let result = coreDataRequestManager.fetchRecipes(context: context)
        
        result.subscribe(onNext: { [unowned self] value in
            self.recipes.accept(value)
        }, onError: { [unowned self] error in
            _ = self.recipes.catch { error in
                Observable.empty()
            }
        }).disposed(by: disposeBag)
    }
    
    func fetchRecipes(title: String) {
        let context = persistentController.mainContext
        let result = coreDataRequestManager.fetchRecipes(context: context, title: title)
        
        result.subscribe(onNext: { [unowned self] value in
            self.recipes.accept(value)
        }, onError: { [unowned self] error in
            _ = self.recipes.catch { error in
                Observable.empty()
            }
        }).disposed(by: disposeBag)
    }
}
