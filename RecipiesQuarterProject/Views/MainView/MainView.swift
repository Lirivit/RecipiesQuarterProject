//
//  MainView.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 13.11.2021.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MainView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Find Recipe \nRight Now"
        label.numberOfLines = 0
        label.font = .classic(20)
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "downArrow")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    //
    //    private var searchBar: UITextField = {
    //        let textField = UITextField()
    //        textField.placeholder = "Enter recipe name here"
    //        textField.font = .systemFont(ofSize: 15)
    //        textField.borderStyle = .roundedRect
    //        textField.autocorrectionType = .no
    //        textField.keyboardType = .default
    //        textField.returnKeyType = .search
    //        textField.clearButtonMode = .whileEditing
    //        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    ////        textField.rx.text.bind { value in
    ////            dele
    ////        }
    //        return textField
    //    }()
    //
    private var popularRecipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        collectionView.delegate = nil
//        collectionView.dataSource = nil
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    // Init
    init() {
        super.init(frame: CGRect.zero)
        
        // Setup
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        
        addSubview(headerLabel)
        addSubview(arrowImage)
        addSubview(popularRecipesCollectionView)
        
        headerLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(self).offset(20)
            make.centerX.equalTo(self)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.height.equalTo(200)
        }
        
        popularRecipesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(arrowImage.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.bottomMargin.equalTo(self).offset(-10)
//            make.height.equalTo(300)
        }
    }
    
    func configureCollectioView(value: [RecipeResult]) {
        let items: BehaviorRelay<[RecipeResult]> = BehaviorRelay(value: value)
        
        items.bind(to: popularRecipesCollectionView.rx.items(
                    cellIdentifier: MainCollectionViewCell.cellIdentifier,
                    cellType: MainCollectionViewCell.self)) { row, data, cell in
            cell.configure(recipeLabel: data.title, recipeImage: data.image)
        }
        .disposed(by: disposeBag)
        
        // add this line you can provide the cell size from delegate method
        popularRecipesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
}

// MARK: - Collection View Layout
extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
