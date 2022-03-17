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
    public enum StreamingBitRate: Int {
        case thirtyTwo
        case sixtyFour
        case oneTwentyEight
    }
    
    /// Singleton access to KEXPower
    public static let sharedInstance = KEXPPower()
    
    /// User's selected archive bitrate
    public var selectedBitRate: StreamingBitRate!

    // Generate a random UUID that will be passed to StreamGuys in order to identify this particular
    // streaming "session"
    let listenerId: UUID = .init()

    var playURL: URL {
        URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/v2/plays")!
    }
    var showURL: URL {
        URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/v2/shows")!
    }
    
    var showStartURL: URL {
        URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/get_show_start/")!
    }
            
    var streamingURL: URL {
        URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/get_streaming_url")!
    }

    private var kexpBaseURL: String!

    /// Configure KEXPPower
    /// - Parameters:
    ///   - kexpBaseURL: Base URL for making network requests
    ///   - selectedBitRate: User's selected bitrate
    public func setup(kexpBaseURL: String, selectedBitRate: StreamingBitRate) {
        self.kexpBaseURL = kexpBaseURL
        self.selectedBitRate = selectedBitRate
    }
    
    public var streamURL: URL {
        let availableStreams = AvailableStreams(with: KEXPPower.sharedInstance.listenerId)
        
        return availableStreams.livePlayback[KEXPPower.sharedInstance.selectedBitRate] ??
            URL(string: "https://kexp-mp3-128.streamguys1.com/kexp128.mp3?listenerId=\(listenerId.uuidString)")!
    }
    
    static func getShowURL(with showId: String) -> URL {
        return URL(string: KEXPPower.sharedInstance.kexpBaseURL + "/v2/shows/\(showId)")!
    }

    private init(){}
}
