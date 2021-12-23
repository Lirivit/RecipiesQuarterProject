//
//  VegeteriansViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 15.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class VegeteriansViewController: RecipesListViewController {
    private let disposeBag = DisposeBag()
    
    private var vegeterianRecipesViewModel: VegeterianRecipesViewModel
    
    init(viewModel: VegeterianRecipesViewModel) {
        self.vegeterianRecipesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesListTableView.dataSource = nil
        recipesListTableView.delegate = nil
        setupView()
        bindUI()
        vegeterianRecipesViewModel.searchRecipes(query: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func bindUI() {
        let output = vegeterianRecipesViewModel.transform(VegeterianRecipesViewModel.Input(
            searchText: searchBar.rx.text.orEmpty.throttle(.seconds(1), scheduler: MainScheduler.instance),
            tableViewPagination: recipesListTableView.rx.willDisplayCell, tableViewSelectedItem: recipesListTableView.rx.modelSelected(RecipeResult.self),
            searchBarDoneButton: searchBar.rx.searchButtonClicked))
        
        output.recipesObserver
            .map { $0 }
            .drive(recipesListTableView.rx.items(cellIdentifier: RecipesListTableViewCell.cellIdentifier, cellType: RecipesListTableViewCell.self)) { row, data, cell in
                cell.configure(recipeLabel: data.title, recipeImage: data.image)
            }.disposed(by: disposeBag)
        
        output.recipeObserver.drive(onNext: { [unowned self] id in
            self.pushRecipeViewController(id: id)
        }).disposed(by: disposeBag)
        
        output.searchBarDoneButtonObserver.drive(onNext: {
            self.searchBar.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func pushRecipeViewController(id: Int) {
        let viewModel = RecipeViewModel(id: id)
        
        let recipeViewController = RecipeViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(recipeViewController, animated: true)
    }
}

