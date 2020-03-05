//
//  PlayResultV2.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 3/3/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import Foundation

// MARK: - PlayResultV2
public struct PlayResultV2: Decodable {
    let next: String?
    let previous: String?
    let results: [PlayV2]?
}

// MARK: - Result
public struct PlayV2: Decodable {
    let id: Int?
    let uri: String?
    let airdate: String?
    let show: Int?
    let showURI: String?
    let imageURI: String?
    let thumbnailURI: String?
    let comment: String?
    let playType: PlayTypeV2?
    let song: String?
    let trackID: String?
    let recordingID: String?
    let artist: String?
    let artistIDs: [String]?
    let album: String?
    let releaseID: String?
    let releaseGroupID: String?
    let labels: [String]?
    let labelIDs: [String]?
    let releaseDate: String?
    let rotationStatus: String?
    let isLocal: Bool?
    let isRequest: Bool?
    let isLive: Bool?
    
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

public enum PlayTypeV2: String, Decodable {
    case airbreak = "airbreak"
    case trackplay = "trackplay"
}
