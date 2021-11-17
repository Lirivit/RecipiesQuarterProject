//
//  MainViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 13.11.2021.
//

import Foundation
import UIKit
import RxSwift

class MainViewController: UIViewController {
    // Recipes view model
    private var recipesViewModel: RecipeResultViewModel
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Main View
    private lazy var mainView: MainView = {
        let view = MainView()
        return view
    }()
    
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
        bindUI()
    }
    
    func bindUI() {
        // Here I will bind all th UI
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recipesViewModel.recipesObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
            if !value.isEmpty {
                print(value.count)
                self.mainView.configureCollectioView(value: value)
            }
        }).disposed(by: disposeBag)
    }
}
