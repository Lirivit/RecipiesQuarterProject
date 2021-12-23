//
//  FavoriteRecipeViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 11.12.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FavoriteRecipeViewController: UIViewController {
    // Recipe Name
    private lazy var recipeName = UILabel()
//    // Add favorite recipe button
//    private lazy var addFavoriteRecipeButton = UIButton()
    // Recipe Image
    private lazy var recipeImage = UIImageView()
    // Summary text
    private lazy var summaryText = UILabel()
    // Recipe Stat Collection View Layout
    private let recipeStatCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    // Recipe Stat Collection View
    private lazy var recipeStatCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: recipeStatCollectionViewLayout)
    // Recipe Ingredient Collection View Layout
    private let recipeIngredientCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    // Recipe Ingredient Collection View
    private lazy var recipeIngredientCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: recipeIngredientCollectionViewLayout)
    
    private var disposeBag = DisposeBag()
    
    private var favoriteRecipeViewModel: FavoriteRecipeViewModel
    
    init(viewModel: FavoriteRecipeViewModel) {
        self.favoriteRecipeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        
        // Setup View
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        let output = favoriteRecipeViewModel.transform(FavoriteRecipeViewModel.Input())
        
        output.recipeTitle.drive(recipeName.rx.text).disposed(by: disposeBag)
        
        output.recipeImage.drive(onNext: { [unowned self] image in
            self.setupImage(image: image)
        }).disposed(by: disposeBag)
        
//        output.addFavoriteRecipeButtonState.drive(addFavoriteRecipeButton.rx.isSelected).disposed(by: disposeBag)
        
        output.recipeStat.drive(recipeStatCollectionView.rx.items(
            cellIdentifier: RecipeStatCollectionViewCell.cellIdentifier,
            cellType: RecipeStatCollectionViewCell.self)) { row, data, cell in
                cell.configure(name: data.name, image: data.image)
            }.disposed(by: disposeBag)
        
        output.recipeIngredients.drive(recipeIngredientCollectionView.rx.items(cellIdentifier: RecipeIngredientCollectionViewCell.cellIdentifier, cellType: RecipeIngredientCollectionViewCell.self)) { row, data, cell in
            
            if let name = data.title,
                let unit = data.unit {
                let itemAmount = "\(data.amount) \(unit)"
                cell.configure(name: name, image: data.image, amount: itemAmount)
            }
        }.disposed(by: disposeBag)
        
        recipeIngredientCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        recipeStatCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}
// MARK: - Setup UI
extension FavoriteRecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.recipeStatCollectionView {
            return CGSize(width: 75, height: 105)
        } else {
            return CGSize(width: 85, height: 140)
        }
        
    }
    
    private func setupImage(image: String) {
        let imageURL = URL(string: image)
        
        recipeImage.kf.indicatorType = .activity
        recipeImage.kf.setImage(with: imageURL)
    }
    
    private func setupView() {
        title = "Recipe"
        
        recipeName.font = .boldSystemFont(ofSize: 20)
        recipeName.numberOfLines = 0
        recipeName.lineBreakMode = .byWordWrapping
        recipeName.textColor = .black
        
//        let buttonImageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .medium)
//
//        let buttonImageForNormal = UIImage(systemName: "star", withConfiguration: buttonImageConfig)
//
//        let buttonImageForSelected = UIImage(systemName: "star.fill", withConfiguration: buttonImageConfig)
        
//        addFavoriteRecipeButton.setImage(buttonImageForNormal, for: .normal)
//        addFavoriteRecipeButton.setImage(buttonImageForSelected, for: .selected)
        
        recipeImage.contentMode = .scaleAspectFit
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        
        summaryText.font = .modern(16)
        summaryText.numberOfLines = 0
        summaryText.lineBreakMode = .byWordWrapping
        summaryText.textColor = .black
        
        recipeStatCollectionViewLayout.scrollDirection = .horizontal
        recipeStatCollectionViewLayout.minimumInteritemSpacing = 0
        recipeStatCollectionViewLayout.minimumLineSpacing = 0
        recipeStatCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recipeStatCollectionView.backgroundColor = .white
        recipeStatCollectionView.showsHorizontalScrollIndicator = false
        recipeStatCollectionView.register(RecipeStatCollectionViewCell.self, forCellWithReuseIdentifier: RecipeStatCollectionViewCell.cellIdentifier)
        
        recipeIngredientCollectionViewLayout.scrollDirection = .horizontal
        recipeIngredientCollectionViewLayout.minimumInteritemSpacing = 0
        recipeIngredientCollectionViewLayout.minimumLineSpacing = 0
        recipeIngredientCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recipeIngredientCollectionView.backgroundColor = .white
        recipeIngredientCollectionView.showsHorizontalScrollIndicator = false
        recipeIngredientCollectionView.register(RecipeIngredientCollectionViewCell.self, forCellWithReuseIdentifier: RecipeIngredientCollectionViewCell.cellIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(recipeName)
//        view.addSubview(addFavoriteRecipeButton)
        view.addSubview(recipeImage)
        view.addSubview(recipeStatCollectionView)
        view.addSubview(recipeIngredientCollectionView)
        
        recipeName.snp.makeConstraints { make in
            make.topMargin.equalTo(view).offset(15)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            //            make.height.equalTo(50)
        }
        
//        addFavoriteRecipeButton.snp.makeConstraints { make in
//            make.topMargin.equalTo(view).offset(10)
//            make.trailing.equalTo(view).offset(-15)
//            make.height.equalTo(40)
//            make.width.equalTo(40)
//        }
        
        recipeImage.snp.makeConstraints { make in
            make.top.equalTo(recipeName.snp.bottom).offset(20)
            make.leading.equalTo(recipeName)
            make.trailing.equalTo(recipeName)
            make.height.equalTo(200)
        }
        
        recipeStatCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(15)
            make.leading.equalTo(view).offset(5)
            make.trailing.equalTo(view).offset(-15)
            //            make.bottom.equalTo(summaryText.snp.top).offset(10)
            make.height.equalTo(105)
        }
        
        recipeIngredientCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recipeStatCollectionView.snp.bottom).offset(15)
            make.leading.equalTo(view).offset(5)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(140)
        }
    }
}



