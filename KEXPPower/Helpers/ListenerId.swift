//
//  ListenerId.swift
//  KEXPPower
//
//  Created by Adam Bourn on 1/22/22.
//  Copyright © 2022 KEXP. All rights reserved.
//

import Foundation


class ListenerId {
    // Singleton ListenerId
    public static let sharedInstance = ListenerId()

    // Generate a random UUID that will be passed to StreamGuys in order to identify this particular
    // streaming "session"
    let listenerId: UUID = .init()
    
    private init() {}

    public func append(toURL url: URL) -> URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "listenerId", value: listenerId.uuidString)
        ]
        if let urlWithListenerId = urlComponents?.url {
            return urlWithListenerId
        }
        return url
    }
}
