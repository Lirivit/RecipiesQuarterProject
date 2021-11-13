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
}

enum RequestError: Error {
    case incorrectURL
}

enum Endpoint {
    case recipesSearch
    
    var route: String {
        switch self {
        case .recipesSearch:
            return "/recipes/complexSearch"
        }
    }
}

struct NetworkRequest {
    let httpMethod: HTTPMethod
    let endpoint: Endpoint
    var headers: [String: String] = ["Content-Type" : "application/json"]
}


