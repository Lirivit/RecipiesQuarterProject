//
//  RequestManager.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 12.11.2021.
//

import Foundation
import RxSwift

struct RequestManager {
    
    private let client = RequestExecutor.client
    
    func requestRecipes(request: NetworkRequest, key: String, numberOfRecipes: Int, page: Int) -> Observable<RecipesResults> {
        
        let params: [String: Any] = [
            "apiKey": key,
            "number": numberOfRecipes,
            "offset": page
        ]
        
        let result: Observable<RecipesResults> = client.executeRequest(request: request, params: params)
        
        return result
    }
}
