//
//  Recipe.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 03.11.2021.
//

import Foundation

struct RecipesResults: Codable {
    var results: [RecipeResult] = []
    var totalResults: Int
}

struct RecipeResult: Codable {
    let id: Int
    let title: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
    }
}

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let vegetarian: Bool
    let vegan: Bool
    let veryPopular: Bool
    let veryHealthy: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let ingredients: [RecipeIngredients]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case vegetarian
        case vegan
        case veryPopular
        case veryHealthy
        case glutenFree
        case dairyFree
        case ingredients = "extendedIngredients"
    }
}

struct RecipeIngredients: Codable {
    let id: Int
    let name: String
    let image: String?
    let amount: Double
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case amount
        case unit
    }
}
