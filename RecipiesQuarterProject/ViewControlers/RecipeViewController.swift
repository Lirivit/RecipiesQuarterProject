//
//  RecipeViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 25.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class RecipeViewController: UIViewController {
    // Recipe Name
    private lazy var recipeName = UILabel()
    // Add favorite recipe button
    private lazy var addFavoriteRecipeButton = UIButton()
    // Recipe Image
    private lazy var recipeImage = UIImageView()
    // Summary text
    private lazy var summaryText = UILabel()
    // Recipe Stat Collection View Layout
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    // Recipe Stat Collection View
    private lazy var recipeStatCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    private var disposeBag = DisposeBag()
    
    private var recipeViewModel: RecipeViewModel
    
    private var id: Int
    
    init(viewModel: RecipeViewModel, id: Int) {
        self.recipeViewModel = viewModel
        self.id = id
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
        
        recipeViewModel.requestRecipe(recipeId: self.id)
        bindUI()
    }
    
    private func bindUI() {
        let output = recipeViewModel.transform(RecipeViewModel.Input())
        
        output.recipeTitle.drive(recipeName.rx.text).disposed(by: disposeBag)
        
//        output.recipeSummary.drive(summaryText.rx.text).disposed(by: disposeBag)
        
        output.recipeStat.drive(recipeStatCollectionView.rx.items(
            cellIdentifier: RecipeStatCollectionViewCell.cellIdentifier,
            cellType: RecipeStatCollectionViewCell.self)) { row, data, cell in
                cell.configure(name: data.name, image: data.image)
            }.disposed(by: disposeBag)
        
        recipeStatCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}
// MARK: - Setup UI
extension RecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 75, height: 105)
    }
    
    private func setupView() {
        recipeName.font = .systemFont(ofSize: 20)
        recipeName.numberOfLines = 0
        recipeName.lineBreakMode = .byWordWrapping
        recipeName.textColor = .black
        
        let buttonImageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .medium)
        
        let buttonImageForNormal = UIImage(systemName: "star", withConfiguration: buttonImageConfig)
        
        let buttonImageForSelected = UIImage(systemName: "star.fill", withConfiguration: buttonImageConfig)
        
        addFavoriteRecipeButton.setImage(buttonImageForNormal, for: .normal)
        addFavoriteRecipeButton.setImage(buttonImageForSelected, for: .selected)
        
        recipeImage.contentMode = .scaleAspectFit
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        
        summaryText.font = .modern(16)
        summaryText.numberOfLines = 0
        summaryText.lineBreakMode = .byWordWrapping
        summaryText.textColor = .black
        
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        recipeStatCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recipeStatCollectionView.backgroundColor = .white
        recipeStatCollectionView.showsHorizontalScrollIndicator = false
        recipeStatCollectionView.register(RecipeStatCollectionViewCell.self, forCellWithReuseIdentifier: RecipeStatCollectionViewCell.cellIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(recipeName)
        view.addSubview(addFavoriteRecipeButton)
        view.addSubview(recipeImage)
        view.addSubview(recipeStatCollectionView)
        view.addSubview(summaryText)
        
        recipeName.snp.makeConstraints { make in
            make.topMargin.equalTo(view).offset(10)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(addFavoriteRecipeButton.snp.leading).offset(-20)
//            make.height.equalTo(50)
        }
        
        addFavoriteRecipeButton.snp.makeConstraints { make in
            make.topMargin.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        recipeImage.snp.makeConstraints { make in
            make.top.equalTo(recipeName.snp.bottom).offset(10)
            make.leading.equalTo(recipeName)
            make.trailing.equalTo(addFavoriteRecipeButton)
            make.height.equalTo(200)
        }
        
        recipeStatCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(5)
            make.trailing.equalTo(view).offset(-15)
//            make.bottom.equalTo(summaryText.snp.top).offset(10)
            make.height.equalTo(105)
        }
        
        summaryText.snp.makeConstraints { make in
            make.top.equalTo(recipeStatCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(recipeName)
            make.trailing.equalTo(recipeName)
        }
    }
}
