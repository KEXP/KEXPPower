//
//  NetworkManager.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

public struct NetworkManager {
    public typealias PlayCompletion = (_ result: Result<String>, _ playResult: PlayResult?) -> Void
    public typealias ShowCompletion = (_ result: Result<String>, _ showResult: ShowResult?) -> Void
    public typealias ConfigurationCompletion = (_ result: Result<String>, _ configuration: Configuration?) -> Void
    
    private let router = Router()
    private let reachability = Reachability()
    
    public init() {}
    
    public var isReachability: Bool {
        return reachability.isReachable()
    }

    public func getPlay(
        playid: String? = nil,
        beginTime: String? = nil,
        endTime: String? = nil,
        limit: Int = 20,
        offset: Int = 0,
        completion: @escaping PlayCompletion)
    {
        var parameters = [URLQueryItem]()

        if let playid = playid {
            parameters.append(URLQueryItem(name: "playid", value: playid))
        }

        if let beginTime = beginTime {
            parameters.append(URLQueryItem(name: "begin_time", value: beginTime))
        }
        
        if let endTime = endTime {
            parameters.append(URLQueryItem(name: "end_time", value: endTime))
        }
        
        parameters.append(URLQueryItem(name: "limit", value: "\(limit)"))
        parameters.append(URLQueryItem(name: "offset", value: "\(offset)"))
        
        router.get(url: KEXPPower.playURL, parameters: parameters) { result, data in
            guard
                case .success = result,
                let data = data
            else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.airDateFormatter)
                let playResult = try decoder.decode(PlayResult.self, from: data)
                
                completion(Result.success, playResult)
            } catch let error {
                completion(Result.failure(error.localizedDescription), nil)
            }
        }
    }

    public func getShow(
        showId: String? = nil,
        airDateExact: String? = nil,
        airDateBefore: String? = nil,
        airDateAfter: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        completion: @escaping ShowCompletion)
    {
        var parameters = [URLQueryItem]()
        
        if let showId = showId {
            parameters.append(URLQueryItem(name: "showId", value: showId))
        }
        
        if let airDateExact = airDateExact {
            parameters.append(URLQueryItem(name: "airdate_exact", value: airDateExact))
        }
        
        if let airDateAfter = airDateAfter {
            parameters.append(URLQueryItem(name: "airdate_after", value: airDateAfter))
        }
        
        if let airDateBefore = airDateBefore {
            parameters.append(URLQueryItem(name: "airdate_before", value: airDateBefore))
        }
        
        if let limit = limit {
            parameters.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        
        if let offset = offset {
            parameters.append(URLQueryItem(name: "offset", value: "\(offset)"))
        }
        
        router.get(url: KEXPPower.showURL, parameters: parameters) { result, data in
            guard
                case .success = result,
                let data = data
            else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.airDateFormatter)
                
                let showResult = try decoder.decode(ShowResult.self, from: data)

                completion(Result.success, showResult)
            } catch let error {
                completion(Result.failure(error.localizedDescription), nil)
            }
        }
    }
    
    public func getConfiguration(completion: ConfigurationCompletion) {
        guard
            let configurationURL = KEXPPower.configurationURL,
            let data = try? Data(contentsOf: configurationURL)
        else {
            completion(.failure("failure"), nil)
            
            return
        }
        
        do {
            let configuration = try JSONDecoder().decode(Configuration.self, from: data)
            
            completion(Result.success, configuration)
        } catch let error {
            completion(Result.failure(error.localizedDescription), nil)
        }
    }
}
