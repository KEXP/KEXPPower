//
//  ShowResult.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 6/30/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

// MARK: - ShowResult

public struct ShowResult: Decodable {
    public let next: URL?
    public let previous: URL?
    public let showlist: [Show]?
    
    enum CodingKeys: String, CodingKey {
        case next
        case previous
        case showlist = "results"
    }
}

// MARK: - Show

public struct Show: Decodable {
    public let showId: Int
    public let program: Program?
    public let airDate: Date
    public let epochAirDate: Int?
    public let epochAirDateV2: String?
    public let tagline: String?
    public let hosts: [Host]?
    public let archiveURLs: ArchiveURLs?
    
    enum CodingKeys: String, CodingKey {
        case showId = "showid"
        case program
        case airDate = "airdate"
        case epochAirDate = "epoch_airdate"
        case epochAirDateV2 = "epoch_airdate_v2"
        case archiveURLs = "archive_urls"
        case tagline
        case hosts
    }
}

// MARK: - Host

public struct Host: Decodable {
    public let hostId: Int
    public let name: String
    public let imageURL: URL?
    public let isActive: Bool
    
    //Error parsing as a URL, lots of extra white from platform
    public let newImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case hostId = "hostid"
        case name
        case imageURL = "imageuri"
        case newImageURL = "newimageuri"
        case isActive = "isactive"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hostId = try container.decode(Int.self, forKey: .hostId)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        newImageURL = try container.decodeIfPresent(String.self, forKey: .newImageURL)
        isActive = try container.decode(Bool.self, forKey: .isActive)
    }
}

// MARK: - Program

public struct Program: Decodable {
    public let programId: Int
    public let channel: Channel
    public let name: String
    public let description: String?
    public let tags: String?
    
    enum CodingKeys: String, CodingKey {
        case programId = "programid"
        case channel
        case name
        case description
        case tags
    }
}

// MARK: - Channel

public struct Channel: Decodable {
    public let channelId: Int
    public let name: String
    public let streamURL: URL?
    public let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channelid"
        case name
        case streamURL = "streamuri"
        case timezone
    }
}
