//
//  Router.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

public enum Result<String>{
    case success
    case failure(String)
}

typealias Completion = (_ result: Result<String>, _ data: Data?) -> Void

class Router {
    enum NetworkError: Error {
        case serverError(String)
    }
    
    func get(url :URL, parameters: [URLQueryItem]?, completion: @escaping Completion) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = parameters
        
        guard
            let requestURL = urlComponents?.url
            else {
                completion(Result.failure("Error building URL"), nil)
                
                return
        }
        
        var request = URLRequest(url: requestURL)
        request.cachePolicy = .reloadIgnoringLocalCacheData  

        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    (200 ..< 300) ~= response.statusCode,
                    error == nil
                    else {
                        completion(Result.failure("Error from platform: \(error.debugDescription)"), nil)
                        throw NetworkError.serverError("Platform server error")
                }
                
                completion(Result.success, data)
            } catch {
                completion(Result.failure("Board creation failed with error: \(error.localizedDescription)"), nil)
            }
        }.resume()
    }
}
