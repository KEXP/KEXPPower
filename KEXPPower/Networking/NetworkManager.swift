//
//  NetworkManager.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

public struct NetworkManager {
    public typealias PlayCompletion = (_ result: Result<PlayResult?, Error>) -> Void
    public typealias ShowCompletion = (_ result: Result<ShowResult?, Error>) -> Void
    public typealias ShowDetailsCompletion = (_ result: Result<Show?, Error>) -> Void
    public typealias ArchiveCompletion = (_ result: Result<ArchiveStreamResult?, Error>) -> Void
    public typealias AppleMusicCompletion = (_ result: Result<AppleMusicResult?, Error>) -> Void
    
    private let router = Router()
    private let reachability = Reachability()
    
    public init() {}
    
    public var isReachability: Bool {
        return reachability.isReachable()
    }

    public func getPlay(
        airdateBefore: String? = nil,
        limit: Int = 20,
        offset: Int = 0,
        queue: DispatchQueue = .main,
        completion: @escaping PlayCompletion)
    {
        var parameters = [URLQueryItem]()

        if let airdateBefore = airdateBefore {
            parameters.append(URLQueryItem(name: "airdate_before", value: airdateBefore))
        }
        
        parameters.append(URLQueryItem(name: "limit", value: "\(limit)"))
        parameters.append(URLQueryItem(name: "offset", value: "\(offset)"))
        
        router.get(url: KEXPPower.sharedInstance.playURL, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let playResult = try JSONDecoder().decode(PlayResult.self, from: data)

                    queue.async { completion(.success(playResult)) }
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    queue.async { completion(.failure(error)) }
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                queue.async { completion(.failure(error)) }
            }
        }
    }
    
    public func getShow(
        startTimeBefore: String? = nil,
        startTimeAfter: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        queue: DispatchQueue = .main,
        completion: @escaping ShowCompletion)
    {
        var parameters = [URLQueryItem]()
        
        if let startTimeBefore = startTimeBefore {
            parameters.append(URLQueryItem(name: "start_time_before", value: startTimeBefore))
        }
        
        if let startTimeAfter = startTimeAfter {
            parameters.append(URLQueryItem(name: "start_time_after", value: startTimeAfter))
        }
        
        if let limit = limit {
            parameters.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        
        if let offset = offset {
            parameters.append(URLQueryItem(name: "offset", value: "\(offset)"))
        }

        router.get(url: KEXPPower.sharedInstance.showURL, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let showResult = try JSONDecoder().decode(ShowResult.self, from: data)

                    queue.async { completion(.success(showResult)) }
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    queue.async { completion(.failure(error)) }
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                queue.async { completion(.failure(error)) }
            }
        }
    }
    
    public func getShowDetails(
        with showId: String,
        queue: DispatchQueue = .main,
        completion: @escaping ShowDetailsCompletion)
    {
        router.get(url: KEXPPower.getShowURL(with: showId)) { result in
            switch result {
            case .success(let data):
                do {
                    let showDetails = try JSONDecoder().decode(Show.self, from: data)

                    queue.async { completion(.success(showDetails)) }
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    queue.async { completion(.failure(error)) }
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                queue.async { completion(.failure(error)) }
            }
        }
    }
    
    public func getShowStart(
        with streamTime: String,
        queue: DispatchQueue = .main,
        completion: @escaping ShowDetailsCompletion)
    {
        var parameters = [URLQueryItem]()
        parameters.append(URLQueryItem(name: "stream_time", value: streamTime))

        router.get(url: KEXPPower.sharedInstance.showStartURL, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let showDetails = try JSONDecoder().decode(Show.self, from: data)

                    queue.async { completion(.success(showDetails)) }
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    queue.async { completion(.failure(error)) }
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                queue.async { completion(.failure(error)) }
            }
        }
    }
    
    public func getArchiveStreamURL(timestamp: String?, queue: DispatchQueue = .main, completion: @escaping ArchiveCompletion) {
        var parameters = [URLQueryItem]()
        parameters.append(URLQueryItem(name: "timestamp", value: timestamp))
        
        router.get(url: KEXPPower.sharedInstance.streamingURL, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let archiveStreamResult = try JSONDecoder().decode(ArchiveStreamResult.self, from: data)
                    queue.async { completion(.success(archiveStreamResult)) }
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    queue.async { completion(.failure(error)) }
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                queue.async { completion(.failure(error)) }
            }
        }
    }
    
    public func getAppleMusicLink(artist: String?, track: String?, queue: DispatchQueue = .main, completion: @escaping AppleMusicCompletion) {
        let itunesURL = "https://itunes.apple.com/search"
        let searchTerm = "\(artist ?? "") \(track ?? "")"
        var parameters = [URLQueryItem]()
        parameters.append(URLQueryItem(name: "term", value: searchTerm))
        parameters.append(URLQueryItem(name: "entity", value: "song"))

        router.get(url: URL(string: itunesURL)!, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let appleMusicResult = try JSONDecoder().decode(AppleMusicResult.self, from: data)
                    queue.async { completion(.success(appleMusicResult)) }
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    queue.async { completion(.failure(error)) }
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                queue.async { completion(.failure(error)) }
            }
        }
    }
}
