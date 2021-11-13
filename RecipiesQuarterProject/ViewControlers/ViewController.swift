//
//  ViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 28.10.2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    // Recipes view model
    private var recipesViewModel: RecipeResultViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: RecipeResultViewModel) {
        self.recipesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesViewModel.searchRecipes(numberOfRecipes: 10, page: 1)
        
    }
    
    func bindUI() {
        // Here I will bind all th UI
        recipesViewModel.recipesObserver.subscribe(onNext: { value in
            print(value.count)
        }).disposed(by: disposeBag)
        
    }
}

