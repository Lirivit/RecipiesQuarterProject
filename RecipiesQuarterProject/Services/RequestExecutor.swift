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

protocol RequestExecutorProtocol {
    func executeRequest<T: Codable>(request: NetworkRequest) -> Observable<T>
    func createRequest(request: NetworkRequest) -> URLRequest?
}

class RequestExecutor: RequestExecutorProtocol {
    
    func executeRequest<T: Codable>(request: NetworkRequest) -> Observable<T> {
        
        return Observable<T>.create { observer in
            
            guard let request = self.createRequest(request: request) else {
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
                        print(parseError)
                        observer.onError(parseError)
                    }
                    
                    observer.onCompleted()
                }
            
            return Disposables.create()
        }
    }
    
    func createRequest(request: NetworkRequest) -> URLRequest? {
        var components = URLComponents(string: Environment.baseURL + request.endpoint.route)
        
        if !request.parameters.isEmpty {
            let queryItems = request.parameters.map {
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
        return urlRequest
    }
}

