//
//  RequestExecutor.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 12.11.2021.
//

import Foundation
import Alamofire
import RxSwift

private struct Environment {
    static let baseURL: String = "https://api.spoonacular.com"
}

struct RequestExecutor {
    
    static let client = RequestExecutor()
    
    func executeRequest<T: Codable>(request: NetworkRequest, params: [String: Any]) -> Observable<T> {
        
        return Observable<T>.create { observer in
            
            guard let request = createRequest(request: request, params: params) else {
                observer.onError(RequestError.incorrectURL)
                return Disposables.create()
            }
            
            AF.request(request)
                .validate()
                .responseData { response in
                    do {
                        if let data = response.value {
                            let result = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(result)
                        }
                    } catch let parseError {
                        observer.onError(parseError)
                    }
                    
                    observer.onCompleted()
                }
            
            return Disposables.create()
        }
    }
    
    private func createRequest(request: NetworkRequest, params: [String: Any]) -> URLRequest? {
        var components = URLComponents(string: Environment.baseURL + request.endpoint.route)
        
        if !params.isEmpty {
            let queryItems = params.map {
                URLQueryItem(name: $0, value: "\($1)")
            }
            components?.queryItems = queryItems
        }
        
        guard let url = components?.url else {
            debugPrint("Bad url")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        //        print(components?.url?.absoluteString)
        return urlRequest
    }
}

