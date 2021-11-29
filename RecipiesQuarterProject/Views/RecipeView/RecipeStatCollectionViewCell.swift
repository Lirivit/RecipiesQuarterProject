//
//  RecipeStatCollectionViewCell.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 28.11.2021.
//

import Foundation
import UIKit
import Kingfisher

class RecipeStatCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RecipeStatCollectionViewCell"
    
    private var borderedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var recipeStatImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var recipeStatLabel: UILabel = {
        let label = UILabel()
        label.font = .modern(16)
        label.numberOfLines = 0
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
        borderedBackgroundView.addSubview(recipeStatImage)
        borderedBackgroundView.addSubview(recipeStatLabel)
        
        borderedBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        recipeStatImage.snp.makeConstraints { make in
            make.top.equalTo(borderedBackgroundView).offset(5)
            make.centerX.equalTo(borderedBackgroundView)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        recipeStatLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeStatImage.snp.bottom).offset(10)
            make.centerX.equalTo(borderedBackgroundView)
        }
    }
    
    func configure(name: String, image: UIImage?) {
        recipeStatImage.image = image
        recipeStatLabel.text = name
    }
}
