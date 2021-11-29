//
//  MainViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 13.11.2021.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController {
    // Recipes view model
    private var recipesViewModel: RecipeResultViewModel
    // Dispose bag
    private let disposeBag = DisposeBag()
    // Header View label
    private lazy var headerLabel: UILabel = UILabel()
    // Arrow Image View
    private lazy var arrowImage: UIImageView = UIImageView()
    // Search Bar
    private lazy var searchBar: UISearchBar = UISearchBar()
    // Recipes Collection View Layout
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    // Recipes Collection View
    private lazy var popularRecipesCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    init(viewModel: RecipeResultViewModel) {
        self.recipesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        recipesViewModel.searchRecipes(page: 1)
        bindUI()
    }
    
    private func goToSuccessScreen() {
        let searchRecipesViewModel = SearchRecipesViewModel()
        
        let viewController = SearchRecipesViewController(
            viewModel: searchRecipesViewModel)
        
        guard let tabBarController = tabBarController?.viewControllers?[1] as? UINavigationController else {
            return
        }
        
        tabBarController.pushViewController(viewController, animated: true)
        self.tabBarController?.selectedIndex = 1
    }
}

// MARK: - Bind UI
extension MainViewController {
    private func bindUI() {
        let output = recipesViewModel.transform(RecipeResultViewModel.Input(
            searchBarText: searchBar.rx.text.orEmpty.distinctUntilChanged(),
            searchTapped: searchBar.rx.textDidBeginEditing))
        
        output.searchBarText.drive(headerLabel.rx.text).disposed(by: disposeBag)
        output.searchTapped.drive(onNext: goToSuccessScreen).disposed(by: disposeBag)
        
        output.collectionViewObserver
            .map { $0 }
            .drive(popularRecipesCollectionView.rx.items(
                cellIdentifier: MainCollectionViewCell.cellIdentifier,
                cellType: MainCollectionViewCell.self)) { row, data, cell in
                    cell.configure(recipeLabel: data.title, recipeImage: data.image)
                }.disposed(by: disposeBag)
        
        popularRecipesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}
// MARK: - Setup UI
extension MainViewController {
    private func setupView() {
        headerLabel.text = "Search Recipes \nRight Now"
        headerLabel.numberOfLines = 0
        headerLabel.textColor = .black
        headerLabel.font = .classic(20)
        
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.image = UIImage(named: "downArrow")
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        popularRecipesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        popularRecipesCollectionView.backgroundColor = .white
        popularRecipesCollectionView.showsHorizontalScrollIndicator = false
        popularRecipesCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.cellIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(headerLabel)
        view.addSubview(arrowImage)
        view.addSubview(searchBar)
        view.addSubview(popularRecipesCollectionView)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(40)
            make.centerX.equalTo(view)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.height.equalTo(200)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(arrowImage.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            //            make.bottom.equalTo(popularRecipesCollectionView.snp.top).offset(-10)
        }
        
        popularRecipesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.bottomMargin.equalTo(view).offset(-10)
        }
    }
}
// MARK: - Collection View Layout Delegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
