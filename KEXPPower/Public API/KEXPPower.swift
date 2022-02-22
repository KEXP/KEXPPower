//
//  KEXPPower.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

/// Available Stream Entry
public typealias AvailableStream = (streamName: String, streamURL: URL)

/// Archive Stream Entry
public typealias ArchiveStream = (archiveBitRate: ArchiveBitRate, streamURL: URL)

/// Available archive bit rates
public enum ArchiveBitRate: String {
    case thirtyTwo = "32"
    case sixtyFour = "64"
    case oneTwentyEight = "128"
}

/// Class used to configure KEXP networking
public class KEXPPower {
    /// Singleton access to KEXPower
    public static let sharedInstance = KEXPPower()
    
    /// User's selected archive bitrate
    public static var selectedArchiveBitRate: ArchiveBitRate!
    
    /// Available live streams the user can choose from
    public static var availableStreams: [AvailableStream]?
    
    /// Available archive streams the user can choose from
    public static var archiveStreams: [ArchiveStream]?
    
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
    ///   - configurationURL: URL for retrieving app configuration file
    ///   - availableStreams: Available live streams the user can choose from
    ///   - archiveStreams: Available archive streams the user can choose from
    ///   - selectedArchiveBitRate: User's selected archive bitrate
    public func setup(
        kexpBaseURL: String,
        configurationURL: URL? = nil,
        availableStreams: [AvailableStream],
        archiveStreams: [ArchiveStream]? = nil,
        selectedArchiveBitRate: ArchiveBitRate)
    {
        KEXPPower.kexpBaseURL = kexpBaseURL
        KEXPPower.configurationURL = configurationURL
        KEXPPower.availableStreams = availableStreams.map({ (stream) -> AvailableStream in
            return AvailableStream(streamName: stream.streamName,
                                   streamURL: KEXPPower.appendListenerId(toURL: stream.streamURL))
        })
        KEXPPower.archiveStreams = archiveStreams?.map({ (stream) -> ArchiveStream in
            return ArchiveStream(archiveBitRate: stream.archiveBitRate,
                                 streamURL: KEXPPower.appendListenerId(toURL: stream.streamURL))
        })
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
        guard
            let defaultStreamURL = availableStreams?.first?.streamURL
        else {
            assertionFailure("Gotta have a streamURL dude.")
            
            return URL(string: "")!
        }
        
        return defaultStreamURL
    }
    
    static func getShowURL(with showId: String) -> URL {
        return URL(string: kexpBaseURL + "/v2/shows/\(showId)")!
    }

    private init(){}
}
