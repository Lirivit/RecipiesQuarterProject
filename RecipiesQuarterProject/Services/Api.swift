//
//  Api.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 28.10.2021.
//

import Foundation
import Alamofire

public struct Constants {
    static let apiKey = "44e1e5ba948a42009e5e034bdc5cb3ea"
    static let headers = ["Content-Type" : "application/json"]
}

enum RequestError: Error {
    case incorrectURL
    case appDelegateError
    case coreDataFetchError
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


