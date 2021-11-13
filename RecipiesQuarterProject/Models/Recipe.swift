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
}
