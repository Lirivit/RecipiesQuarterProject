//
//  RecipesListViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 20.11.2021.
//

import UIKit

class RecipesListViewController: UIViewController {
    // Search Bar
    lazy var searchBar: UISearchBar = UISearchBar()
    // Recipes Table View
    lazy var recipesListTableView: UITableView = UITableView()
    
    override func loadView() {
        super.loadView()
        
        // Setup View
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
// MARK: - UI Setup
extension RecipesListViewController {
    private func setupView() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        
        recipesListTableView.translatesAutoresizingMaskIntoConstraints = false
        recipesListTableView.separatorStyle = .none
        recipesListTableView.backgroundColor = .white
        recipesListTableView.isUserInteractionEnabled = true
        recipesListTableView.showsVerticalScrollIndicator = false
        recipesListTableView.estimatedRowHeight = 50
        recipesListTableView.rowHeight = UITableView.automaticDimension
        recipesListTableView.register(RecipesListTableViewCell.self, forCellReuseIdentifier: RecipesListTableViewCell.cellIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(recipesListTableView)
        
        searchBar.snp.makeConstraints { make in
            make.topMargin.equalTo(view).offset(10)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
        }
        
        recipesListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.bottomMargin.equalTo(view).offset(-10)
        }
    }
}
