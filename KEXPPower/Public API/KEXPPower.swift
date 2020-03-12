//
//  KEXPPower.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

public typealias AvailableStream = (streamName: String, streamURL: URL)
public typealias ArchiveStream = (archiveBitRate: ArchiveBitRate, streamURL: URL)

public enum ArchiveBitRate: String {
    case thirtyTwo = "32"
    case sixtyFour = "64"
    case oneTwentyEight = "128"
}

public class KEXPPower {
    public func setup(
        kexpBaseURL: String,
        configurationURL: URL? = nil,
        availableStreams: [AvailableStream],
        archiveStreams: [ArchiveStream]? = nil,
        selectedArchiveBitRate: ArchiveBitRate,
        defaultStreamIndex: Int = 0,
        backupStreamIndex: Int = 0)
    {
        KEXPPower.kexpBaseURL = kexpBaseURL
        KEXPPower.configurationURL = configurationURL
        KEXPPower.availableStreams = availableStreams
        KEXPPower.archiveStreams = archiveStreams
        self.selectedArchiveBitRate = selectedArchiveBitRate
        KEXPPower.defaultStreamIndex = defaultStreamIndex
        KEXPPower.backupStreamIndex = backupStreamIndex
    }

    public static let sharedInstance = KEXPPower()
    static var kexpBaseURL: String!
    static var playURL = URL(string: kexpBaseURL + "/v2/plays")!
    static var showURL = URL(string: kexpBaseURL + "/v2/shows")!
    static var streamingURL = URL(string: kexpBaseURL + "/get_streaming_url")!
    public var selectedArchiveBitRate: ArchiveBitRate!
    
    public static var availableStreams: [AvailableStream]?
    public static var archiveStreams: [ArchiveStream]?
    public static var configurationURL: URL?

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
    
    private init(){}
    
    private static var defaultStreamIndex: Int = 0
    private static var backupStreamIndex: Int = 0
}
