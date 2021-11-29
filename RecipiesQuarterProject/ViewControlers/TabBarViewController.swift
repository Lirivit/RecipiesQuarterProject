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
//        // MARK: - Main View Controller
//        let recipeResultViewModel = RecipeResultViewModel()
//
//        let mainViewController = MainViewController(viewModel: recipeResultViewModel)
//        mainViewController.tabBarItem = UITabBarItem(title: "Home",
//                                                     image: UIImage(systemName: "star"),
//                                                     tag: 0)
//
//        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        
        // MARK: - Search Recipes View Controller
        let searchRecipesViewModel = SearchRecipesViewModel()
        
        let searchRecipesViewController = SearchRecipesViewController(viewModel: searchRecipesViewModel)
        searchRecipesViewController.tabBarItem = UITabBarItem(title: "Search",
                                                              image: UIImage(systemName: "star"), tag: 0)
        
        let searchRecipesNavigationViewController = UINavigationController(rootViewController: searchRecipesViewController)
        
        searchRecipesViewController.title = "Home"
        // MARK: - Favorites View Controller
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorite",
                                                          image: UIImage(systemName: "star"),
                                                          tag: 1)
        
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
        favoritesViewController.title = "Favorite"
        // MARK: - Vegeterians View Controller
        let vegeteriansViewController = VegeteriansViewController()
        vegeteriansViewController.tabBarItem = UITabBarItem(title: "Vegeterian",
                                                            image: UIImage(systemName: "star"),
                                                            tag: 2)
        
        let vegeteriansNavigationController = UINavigationController(rootViewController: vegeteriansViewController)
        
        vegeteriansViewController.title = "Vegeterian"
        // MARK: - Drinks View Controller
        let drinksViewController = DrinksViewController()
        drinksViewController.tabBarItem = UITabBarItem(title: "Drinks",
                                                       image: UIImage(systemName: "star"),
                                                       tag: 3)
        
        let drinksNavigationController = UINavigationController(rootViewController: drinksViewController)
        
        drinksViewController.title = "Drinks"
        // MARK: - Tab Bar Setup
        self.tabBar.backgroundColor = .white
        
        self.viewControllers = [
            searchRecipesNavigationViewController,
            favoritesNavigationController,
            vegeteriansNavigationController,
            drinksNavigationController
        ]
        
        self.selectedViewController = searchRecipesNavigationViewController
    }
}
