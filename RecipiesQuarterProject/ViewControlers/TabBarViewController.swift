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
        // MARK: - Main View Controller
        let recipeResultViewModel = RecipeResultViewModel()
        
        let mainViewController = MainViewController(viewModel: recipeResultViewModel)
        mainViewController.tabBarItem = UITabBarItem(title: "Home",
                                                     image: UIImage(systemName: "star"),
                                                     tag: 0)
        
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        
        // MARK: - Favorites View Controller
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorite",
                                                          image: UIImage(systemName: "star"),
                                                          tag: 1)
        
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
        // MARK: - Vegeterians View Controller
        let vegeteriansViewController = VegeteriansViewController()
        vegeteriansViewController.tabBarItem = UITabBarItem(title: "Vegeterian",
                                                            image: UIImage(systemName: "star"),
                                                            tag: 2)
        
        let vegeteriansNavigationController = UINavigationController(rootViewController: vegeteriansViewController)
        
        // MARK: - Drinks View Controller
        let drinksViewController = DrinksViewController()
        drinksViewController.tabBarItem = UITabBarItem(title: "Drinks",
                                                       image: UIImage(systemName: "star"),
                                                       tag: 3)
        
        let drinksNavigationController = UINavigationController(rootViewController: drinksViewController)
        
//        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = .white
//        self.tabBar.barTintColor = .white
        
        self.viewControllers = [
            mainNavigationController,
            favoritesNavigationController,
            vegeteriansNavigationController,
            drinksNavigationController
        ]
        
        self.selectedViewController = mainNavigationController
        
        
    }
}
