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
}

class RequestManager: RequestExecutor, RequestManagerProtocol {
    
    func requestRecipes(request: NetworkRequest) -> Observable<RecipesResults> {
        
        let result: Observable<RecipesResults> = executeRequest(request: request)
        
        return result
    }
}
