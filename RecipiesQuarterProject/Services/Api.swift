//
//  Api.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 28.10.2021.
//

import Foundation
import Alamofire

public struct Constants {
    static let apiKey = "f1354e3f480d459ca0752b557c9edcd9"
    static let headers = ["Content-Type" : "application/json"]
}

enum RequestError: Error {
    case incorrectURL
}

enum Endpoint {
    case recipesSearch
    case singleRecipeInfo(recipeId: Int)
    
    var route: String {
        switch self {
        case .recipesSearch:
            return "/recipes/complexSearch"
        case .singleRecipeInfo(let recipeId):
            return "/recipes/\(recipeId)/information"
        }
    }
}

struct NetworkRequest {
    let httpMethod: HTTPMethod
    let endpoint: Endpoint
    var parameters: [String: Any] = [:]
    var headers: [String: String]
}


