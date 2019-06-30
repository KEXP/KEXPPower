//
//  KEXPPower.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

public typealias AvailableStream = (streamName: String, streamURL: URL)

public struct KEXPPower {
    public static func setup(
        legacyBaseURL: String,
        configurationURL: URL? = nil,
        availableStreams: [AvailableStream],
        defaultStreamIndex: Int = 0,
        backupStreamIndex: Int = 0)
    {
        self.legacyBaseURL = legacyBaseURL
        self.configurationURL = configurationURL
        self.availableStreams = availableStreams
        self.defaultStreamIndex = defaultStreamIndex
        self.backupStreamIndex = backupStreamIndex
    }

    static var legacyBaseURL = "https://legacy-api.kexp.org"
    static var playURL = URL(string: legacyBaseURL + "/play")!
    static var showURL = URL(string: legacyBaseURL + "/show")!
    
    static var availableStreams: [AvailableStream]?
    static var configurationURL = URL(string:"http://www.kexp.org/content/applications/AppleTV/config/KexpConfigResponse.json")

    static var streamURL: URL {
        guard
            let defaultStreamURL = availableStreams?[defaultStreamIndex].streamURL
        else {
            assertionFailure("Gotta have a streamURL dude.")
            
            return URL(string: "")!
        }
        
        return defaultStreamURL
    }

    static var backupStreamURL: URL {
        guard
            let backupStreamURL = availableStreams?[backupStreamIndex].streamURL
        else {
            assertionFailure("Gotta have a streamURL dude.")
            
            return URL(string: "")!
        }
        
        return backupStreamURL
    }
    
    private static var defaultStreamIndex: Int = 0
    private static var backupStreamIndex: Int = 0
}
