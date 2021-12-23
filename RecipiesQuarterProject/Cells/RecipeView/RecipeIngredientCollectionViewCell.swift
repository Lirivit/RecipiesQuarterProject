//
//  RecipeIngredientCollectionViewCell.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 06.12.2021.
//

import Foundation
import UIKit

class RecipeIngredientCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RecipeIngredientCollectionViewCell"
    
    private var borderedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var ingredientAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()
    
    private var ingredientImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var ingredientNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isUserInteractionEnabled = false
        
        addSubview(borderedBackgroundView)
        borderedBackgroundView.addSubview(ingredientAmountLabel)
        borderedBackgroundView.addSubview(ingredientImage)
        borderedBackgroundView.addSubview(ingredientNameLabel)
        
        borderedBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        ingredientAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(borderedBackgroundView).offset(5)
            make.centerX.equalTo(borderedBackgroundView)
        }
        
        ingredientImage.snp.makeConstraints { make in
            make.top.equalTo(ingredientAmountLabel.snp.bottom).offset(5)
            make.centerX.equalTo(borderedBackgroundView)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        ingredientNameLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientImage.snp.bottom).offset(10)
            make.leading.equalTo(borderedBackgroundView)
            make.trailing.equalTo(borderedBackgroundView)
        }
    }
    
    func configure(name: String, image: String?, amount: String) {
        ingredientAmountLabel.text = amount
        if let image = image {
            let imageString = "https://spoonacular.com/cdn/ingredients_100x100/\(image)"
            let imageURL = URL(string: imageString)
            
            ingredientImage.kf.indicatorType = .activity
            ingredientImage.kf.setImage(with: imageURL)
        } else {
            ingredientImage.image = UIImage(named: "emptyImage")
        }
        
        ingredientNameLabel.text = name
    }
}
