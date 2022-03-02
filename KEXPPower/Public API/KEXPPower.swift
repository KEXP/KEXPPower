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
    public var selectedArchiveBitRate: ArchiveBitRate!

    // Generate a random UUID that will be passed to StreamGuys in order to identify this particular
    // streaming "session"
    let listenerId: UUID = .init()
    var playURL = URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/v2/plays")!
    var showURL = URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/v2/shows")!
    var showStartURL = URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/get_show_start/")!
    var streamingURL = URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/get_streaming_url")!

    private var kexpBaseURL: String!

    /// Configure KEXPPower
    /// - Parameters:
    ///   - kexpBaseURL: Base URL for making network requests
    ///   - selectedArchiveBitRate: User's selected archive bitrate
    public func setup(kexpBaseURL: String, selectedArchiveBitRate: ArchiveBitRate) {
        self.kexpBaseURL = kexpBaseURL
        self.selectedArchiveBitRate = selectedArchiveBitRate
    }
    
    public var streamURL: URL {
        let availableStreams = AvailableStreams(with: KEXPPower.sharedInstance.listenerId)
        
        switch KEXPPower.sharedInstance.selectedArchiveBitRate {
        case .thirtyTwo:
            return availableStreams.livePlayback[ArchiveBitRate.thirtyTwo.rawValue]
        case .sixtyFour:
            return availableStreams.livePlayback[ArchiveBitRate.sixtyFour.rawValue]
        case .oneTwentyEight:
            return availableStreams.livePlayback[ArchiveBitRate.oneTwentyEight.rawValue]
        default:
            return availableStreams.livePlayback[ArchiveBitRate.oneTwentyEight.rawValue]
        }
    }
    
    static func getShowURL(with showId: String) -> URL {
        return URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/v2/shows/\(showId)")!
    }

    private init(){}
}
