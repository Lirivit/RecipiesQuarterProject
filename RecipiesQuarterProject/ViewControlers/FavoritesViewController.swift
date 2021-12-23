//
//  FavoritesViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 15.11.2021.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class FavoritesViewController: RecipesListViewController {
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    private var favoriteRecipesViewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
        self.favoriteRecipesViewModel = viewModel
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteRecipesViewModel.fetchRecipes()
    }
    
    private func bindUI() {
        let output = favoriteRecipesViewModel.transform(FavoritesViewModel.Input(
            searchText: searchBar.rx.text.orEmpty.throttle(.seconds(1), scheduler: MainScheduler.instance),
            tableViewCellSelection: recipesListTableView.rx.modelSelected(RecipeCoreData.self),
            searchBarDoneButton: searchBar.rx.searchButtonClicked))
        
        output.recipes
            .map { $0.filter{ $0.id != 0 } }
            .drive(recipesListTableView.rx.items(cellIdentifier: RecipesListTableViewCell.cellIdentifier, cellType: RecipesListTableViewCell.self)) { row, data, cell in
                if let title = data.title, let image = data.image {
                    cell.configure(recipeLabel: title,
                                   recipeImage: image)
                }
            }.disposed(by: disposeBag)
        
        output.recipeIdObserver.drive(onNext: { [unowned self] id in
            self.pushRecipeViewController(id: id)
        }).disposed(by: disposeBag)
        
        output.searchBarDoneButtonObserver.drive(onNext: {
            self.searchBar.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func pushRecipeViewController(id: Int) {
        let viewModel = FavoriteRecipeViewModel(id: id)
        
        let recipeViewController = FavoriteRecipeViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(recipeViewController, animated: true)
    }
}
