//
//  RecipesListTableViewCell.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 20.11.2021.
//

import Foundation
import UIKit
import SnapKit

class RecipesListTableViewCell: UITableViewCell {
    static let cellIdentifier = "RecipesListTableViewCell"
    
    private var borderedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.25
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 1, height: 4)
        view.layer.borderColor = UIColor.lightGray.cgColor
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        selectionStyle = .none
        
        addSubview(borderedBackgroundView)
        borderedBackgroundView.addSubview(recipeImageView)
        borderedBackgroundView.addSubview(recipeTitle)
        
        
        borderedBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(5)
            make.leading.equalTo(self).offset(5)
            make.trailing.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-5)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.equalTo(borderedBackgroundView).offset(10)
            make.leading.equalTo(borderedBackgroundView).offset(10)
            make.bottom.equalTo(borderedBackgroundView).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        recipeTitle.snp.makeConstraints { make in
            make.leading.equalTo(recipeImageView.snp.trailing).offset(5)
            make.trailing.equalTo(borderedBackgroundView).offset(-5)
            make.centerY.equalTo(borderedBackgroundView)
        }
        
        
    }
    
    func configure(recipeLabel: String, recipeImage: String) {
        recipeTitle.text = recipeLabel
        
        let imageURL = URL(string: recipeImage)
        
        recipeImageView.kf.indicatorType = .activity
        recipeImageView.kf.setImage(with: imageURL)
    }
}

