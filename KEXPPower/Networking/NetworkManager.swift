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
    public typealias ArchiveCompletion = (_ result: Result<ArchiveStreamResult?, Error>) -> Void
    public typealias AppleMusicCompletion = (_ result: Result<AppleMusicResult?, Error>) -> Void
    public typealias ConfigurationCompletion = (_ result: Result<Configuration?, Error>) -> Void
    
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
        
        router.get(url: KEXPPower.playURL, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.airDateFormatter)
                    let playResult = try decoder.decode(PlayResult.self, from: data)

                    completion(.success(playResult))
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    completion(.failure(error))
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                completion(.failure(error))
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
        
        router.get(url: KEXPPower.showURL, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.airDateFormatter)
                    let showResult = try decoder.decode(ShowResult.self, from: data)

                    completion(.success(showResult))
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    completion(.failure(error))
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                completion(.failure(error))
            }
        }
    }
    
    public func getConfiguration(completion: ConfigurationCompletion) {
        guard
            let configurationURL = KEXPPower.configurationURL,
            let data = try? Data(contentsOf: configurationURL)
        else {
                let error = NSError(
                domain: "com.kexppower.error",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Failure retrieving config"]
            )
            
            completion(.failure(error))
            return
        }
        
        do {
            let configuration = try JSONDecoder().decode(Configuration.self, from: data)
            completion(.success(configuration))
        } catch let error {
            let error = NSError(
                domain: "com.kexppower.error",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
            )
            
            completion(.failure(error))
        }
    }
    
    public func getArchiveStreamURL(bitrate: String, timestamp: String?, completion: @escaping ArchiveCompletion) {
        var parameters = [URLQueryItem]()
        parameters.append(URLQueryItem(name: "bitrate", value: bitrate))
        parameters.append(URLQueryItem(name: "timestamp", value: timestamp))
        
        router.get(url: KEXPPower.streamingURL, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let archiveStreamResult = try JSONDecoder().decode(ArchiveStreamResult.self, from: data)
                    completion(.success(archiveStreamResult))
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    completion(.failure(error))
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                completion(.failure(error))
            }
        }
    }
    
    public func getAppleMusicLink(artist: String?, track: String?, completion: @escaping AppleMusicCompletion) {
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
                    
                    DispatchQueue.main.async {
                        completion(.success(appleMusicResult))
                    }
                    
                } catch let error {
                    let error = NSError(
                        domain: "com.kexppower.error",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                    )
                    
                    completion(.failure(error))
                }
                
            case .failure(let error):
                let error = NSError(
                    domain: "com.kexppower.error",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
                )
                
                completion(.failure(error))
            }
        }
    }
}
