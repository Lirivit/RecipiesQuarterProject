//
//  TabBarViewController.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 15.11.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup after loading the view
        setup()
    }
    
    private func setup() {
        // MARK: - Search Recipes View Controller
        let searchRecipesViewModel = SearchRecipesViewModel()
        
        let searchRecipesViewController = SearchRecipesViewController(viewModel: searchRecipesViewModel)
        searchRecipesViewController.tabBarItem = UITabBarItem(title: "Search",
                                                              image: UIImage(systemName: "house"), tag: 0)
        
        let searchRecipesNavigationViewController = UINavigationController(rootViewController: searchRecipesViewController)
        
        searchRecipesViewController.title = "Home"
        // MARK: - Favorites View Controller
        let favoriteRecipesViewModel = FavoritesViewModel()
        
        let favoritesViewController = FavoritesViewController(viewModel: favoriteRecipesViewModel)
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorite",
                                                          image: UIImage(systemName: "star"),
                                                          tag: 1)
        
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
        favoritesViewController.title = "Favorite"
        // MARK: - Vegeterians View Controller
        let vegeterianRecipesViewModel = VegeterianRecipesViewModel()
        
        let vegeteriansViewController = VegeteriansViewController(viewModel: vegeterianRecipesViewModel)
        vegeteriansViewController.tabBarItem = UITabBarItem(title: "Vegeterian",
                                                            image: UIImage(systemName: "leaf"),
                                                            tag: 2)
        
        let vegeteriansNavigationController = UINavigationController(rootViewController: vegeteriansViewController)
        
        vegeteriansViewController.title = "Vegeterian"
        // MARK: - Tab Bar Setup
        self.tabBar.backgroundColor = .white
        
        self.viewControllers = [
            searchRecipesNavigationViewController,
            favoritesNavigationController,
            vegeteriansNavigationController
        ]
        
        self.selectedViewController = searchRecipesNavigationViewController
    }
}
