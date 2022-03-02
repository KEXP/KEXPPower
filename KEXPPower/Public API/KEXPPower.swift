//
//  KEXPPower.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

/// Class used to configure KEXP networking
public class KEXPPower {
    /// Available archive bit rates
    public enum ArchiveBitRate: Int {
        case thirtyTwo
        case sixtyFour
        case oneTwentyEight
    }
    
    /// Singleton access to KEXPower
    public static let sharedInstance = KEXPPower()
    
    /// User's selected archive bitrate
    public static var selectedArchiveBitRate: ArchiveBitRate!

    /// URL for retrieving app configuration file
    public static var configurationURL: URL?

    // Generate a random UUID that will be passed to StreamGuys in order to identify this particular
    // streaming "session"
    static let listenerId: UUID = .init()

    static var kexpBaseURL: String!
    static var playURL = URL(string: kexpBaseURL + "/v2/plays")!
    static var showURL = URL(string: kexpBaseURL + "/v2/shows")!
    static var showStartURL = URL(string: kexpBaseURL + "/get_show_start/")!
    static var streamingURL = URL(string: kexpBaseURL + "/get_streaming_url")!

    /// Configure KEXPPower
    /// - Parameters:
    ///   - kexpBaseURL: Base URL for making network requests
    ///   - selectedArchiveBitRate: User's selected archive bitrate
    public func setup(kexpBaseURL: String, selectedArchiveBitRate: ArchiveBitRate) {
        KEXPPower.kexpBaseURL = kexpBaseURL
        KEXPPower.selectedArchiveBitRate = selectedArchiveBitRate
    }

    static func appendListenerId(toURL url: URL) -> URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "listenerId", value: listenerId.uuidString)
        ]
        if let urlWithListenerId = urlComponents?.url {
            return urlWithListenerId
        }
        return url
    }

    static var streamURL: URL {
        let availableStreams = AvailableStreams(with: UUID())
        
        switch selectedArchiveBitRate {
        case .thirtyTwo:
            return availableStreams.livePlayback[ArchiveBitRate.thirtyTwo.hashValue]
        case .sixtyFour:
            return availableStreams.livePlayback[ArchiveBitRate.sixtyFour.hashValue]
        case .oneTwentyEight:
            return availableStreams.livePlayback[ArchiveBitRate.oneTwentyEight.hashValue]
        default:
            return availableStreams.livePlayback[ArchiveBitRate.oneTwentyEight.hashValue]
        }
    }
    
    static func getShowURL(with showId: String) -> URL {
        return URL(string: kexpBaseURL + "/v2/shows/\(showId)")!
    }

    private init(){}
}
