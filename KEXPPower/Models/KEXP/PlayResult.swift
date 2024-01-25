//
//  PlayResult.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 3/3/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import Foundation

// MARK: - PlayResult
public struct PlayResult: Decodable {
    public let next: String?
    public let previous: String?
    public let plays: [Play]?
    
    enum CodingKeys: String, CodingKey {
        case plays = "results"
        case next
        case previous
    }
}

// MARK: - Result
public struct Play: Decodable {
    public let id: Int?
    public let uri: String?
    public let airdate: Date?
    public let show: Int?
    public let showURI: String?
    public let imageURI: String?
    public let thumbnailURI: String?
    public let comment: String?
    public let playType: PlayType?
    public let song: String?
    public let trackID: String?
    public let recordingID: String?
    public let artist: String?
    public let artistIDs: [String]?
    public let album: String?
    public let releaseID: String?
    public let releaseGroupID: String?
    public let labels: [String]?
    public let labelIDs: [String]?
    public let releaseDate: String?
    public let rotationStatus: String?
    public let isLocal: Bool?
    public let isRequest: Bool?
    public let isLive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uri
        case airdate
        case show
        case showURI = "show_uri"
        case imageURI = "image_uri"
        case thumbnailURI = "thumbnail_uri"
        case comment
        case playType = "play_type"
        case song
        case trackID = "track_id"
        case recordingID = "recording_id"
        case artist
        case artistIDs = "artist_ids"
        case album
        case releaseID = "release_id"
        case releaseGroupID = "release_group_id"
        case labels
        case labelIDs = "label_ids"
        case releaseDate = "release_date"
        case rotationStatus = "rotation_status"
        case isLocal = "is_local"
        case isRequest = "is_request"
        case isLive = "is_live"
    }
}

public enum PlayType: String, Decodable {
    case airbreak = "airbreak"
    case trackplay = "trackplay"
    case nontrackplay = "nontrackplay"
}

extension Play {
    public init(id: Int, song: String?, artist: String?, album: String?, label: String?, airDate: Date?, comment: String?, releaseDate: String? = nil) {
        self.id = id
        self.uri = nil
        self.show = nil
        self.showURI = nil
        self.imageURI = nil
        self.thumbnailURI = nil
        self.comment = comment
        self.playType = nil
        self.song = song
        self.trackID = nil
        self.recordingID = nil
        self.artist = artist
        self.artistIDs = []
        self.album = album
        self.releaseID = nil
        self.releaseGroupID = nil
        self.labels = label != nil ? [label!] : []
        self.labelIDs = []
        self.releaseDate = releaseDate
        self.rotationStatus = nil
        self.isLocal = true
        self.isRequest = false
        self.isLive = false
        self.airdate = airDate
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
        show = try values.decodeIfPresent(Int.self, forKey: .show)
        showURI = try values.decodeIfPresent(String.self, forKey: .showURI)
        imageURI = try values.decodeIfPresent(String.self, forKey: .imageURI)
        thumbnailURI = try values.decodeIfPresent(String.self, forKey: .thumbnailURI)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        playType = try values.decodeIfPresent(PlayType.self, forKey: .playType)
        song = try values.decodeIfPresent(String.self, forKey: .song)
        trackID = try values.decodeIfPresent(String.self, forKey: .trackID)
        recordingID = try values.decodeIfPresent(String.self, forKey: .recordingID)
        artist = try values.decodeIfPresent(String.self, forKey: .artist)
        artistIDs = try values.decodeIfPresent([String].self, forKey: .artistIDs)
        album = try values.decodeIfPresent(String.self, forKey: .album)
        releaseID = try values.decodeIfPresent(String.self, forKey: .releaseID)
        releaseGroupID = try values.decodeIfPresent(String.self, forKey: .releaseGroupID)
        labels = try values.decodeIfPresent([String].self, forKey: .labels)
        labelIDs = try values.decodeIfPresent([String].self, forKey: .labelIDs)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        rotationStatus = try values.decodeIfPresent(String.self, forKey: .rotationStatus)
        isLocal = try values.decodeIfPresent(Bool.self, forKey: .isLocal)
        isRequest = try values.decodeIfPresent(Bool.self, forKey: .isRequest)
        isLive = try values.decodeIfPresent(Bool.self, forKey: .isLive)
        
        let dateString = try values.decode(String.self, forKey: .airdate)

        if let parsedDate = DateFormatter.airdateFormatter.date(from: dateString) {
            airdate = parsedDate
        } else if let parsedDate = DateFormatter.airdateMillisecondFormatter.date(from: dateString) {
            airdate = parsedDate
        } else {
            airdate = nil
        }
    }
}
