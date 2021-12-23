//
//  MainCollectionViewCell.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 16.11.2021.
//

import Foundation
import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "MainCollectionViewCell"
    
    private var borderedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var recipeTitle: UILabel = {
        let label = UILabel()
        label.font = .modern(16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()
    
    private var recipeImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
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
        isUserInteractionEnabled = true
        
        addSubview(borderedBackgroundView)
        borderedBackgroundView.addSubview(recipeTitle)
        borderedBackgroundView.addSubview(recipeImageView)
        
        borderedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recipeTitle.snp.makeConstraints { make in
            make.top.equalTo(borderedBackgroundView).offset(20)
//            make.leading.equalTo(borderedBackgroundView).offset(10)
            make.centerX.equalTo(borderedBackgroundView)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.equalTo(recipeTitle.snp.bottom).offset(10)
            make.centerX.equalTo(borderedBackgroundView)
            make.bottom.equalTo(borderedBackgroundView).offset(-10)
//            make.height.equalTo(200)
        }
    }
    
    func configure(recipeLabel: String, recipeImage: String) {
        recipeTitle.text = recipeLabel
        
        let imageURL = URL(string: recipeImage)
        
        recipeImageView.kf.indicatorType = .activity
        recipeImageView.kf.setImage(with: imageURL)
    }
}
