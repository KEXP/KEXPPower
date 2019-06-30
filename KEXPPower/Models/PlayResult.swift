//
//  PlayResult.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 6/30/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

// MARK: - PlayResult

public struct PlayResult: Decodable {
    public let next: URL?
    public let previous: URL?
    public let playlist: [Play]?
    
    enum CodingKeys: String, CodingKey {
        case next
        case previous
        case playlist = "results"
    }
}

// MARK: - Play

public struct Play: Decodable {
    public let playId: Int
    public let playType: PlayType
    public let airDate: Date
    public let epochAirDate: Int?
    public let epochAirDateV2: String?
    public let archiveURLs: ArchiveURLs?
    public let artist: Artist?
    public let release: Release?
    public let releaseEvent: ReleaseEvent?
    public let track: Track?
    public let label: Label?
    public let comments: [Comment]?
    public let showId: Int
    
    enum CodingKeys: String, CodingKey {
        case playId = "playid"
        case playType = "playtype"
        case airDate = "airdate"
        case epochAirDate = "epoch_airdate"
        case epochAirDateV2 = "epoch_airdate_v2"
        case archiveURLs = "archive_urls"
        case artist
        case release
        case releaseEvent = "releaseevent"
        case track
        case label
        case comments
        case showId = "showid"
    }
}

// MARK: - Artist

public struct Artist: Decodable {
    public let artistId: Int?
    public let name: String?
    public let isLocal: Bool?
    
    enum CodingKeys: String, CodingKey {
        case artistId = "artistid"
        case name
        case isLocal = "islocal"
    }
}

// MARK: - Comment

public struct Comment: Decodable {
    public let commentId: Int
    public let text: String
    
    enum CodingKeys: String, CodingKey {
        case commentId = "commentid"
        case text
    }
}

// MARK: - Label

public struct Label: Decodable {
    public let labelId: Int
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case labelId = "labelid"
        case name
    }
}

// MARK: - Playtype
public struct PlayType: Decodable {
    public let playTypeId: Int
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case playTypeId = "playtypeid"
        case name
    }
}

// MARK: - Release

public struct Release: Decodable {
    public let releaseId: Int
    public let name: String
    public let largeImageURL: URL?
    public let smallImageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case releaseId = "releaseid"
        case name
        case largeImageURL = "largeimageuri"
        case smallImageURL = "smallimageuri"
    }
}

// MARK: - ReleaseEvent
public struct ReleaseEvent: Decodable {
    public let releaseEventId: Int?
    public let year: Int?
    
    enum CodingKeys: String, CodingKey {
        case releaseEventId = "releaseeventid"
        case year
    }
}

// MARK: - Track

public struct Track: Decodable {
    public let trackId: Int
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case trackId = "trackid"
        case name
    }
}
