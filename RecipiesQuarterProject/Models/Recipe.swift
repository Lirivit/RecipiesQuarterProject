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
    let summary: String
    let vegetarian: Bool
    let vegan: Bool
    let veryPopular: Bool
    let veryHealthy: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case summary
        case vegetarian
        case vegan
        case veryPopular
        case veryHealthy
        case glutenFree
        case dairyFree
    }
    
}
