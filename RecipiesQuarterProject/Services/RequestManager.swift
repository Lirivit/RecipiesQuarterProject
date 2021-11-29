//
//  RequestManager.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 12.11.2021.
//

import Foundation
import RxSwift

protocol RequestManagerProtocol {
    func requestRecipes(request: NetworkRequest) -> Observable<RecipesResults>
    func requestSingleRecipe(request: NetworkRequest) -> Observable<Recipe>
}

class RequestManager: RequestExecutor, RequestManagerProtocol {
    func requestSingleRecipe(request: NetworkRequest) -> Observable<Recipe> {
        
        let result: Observable<Recipe> = executeRequest(request: request)
        
        return result
    }
    
    
    func requestRecipes(request: NetworkRequest) -> Observable<RecipesResults> {
        
        let result: Observable<RecipesResults> = executeRequest(request: request)
        
        return result
    }
}
