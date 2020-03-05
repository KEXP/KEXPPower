//
//  ShowResultsV2.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 3/3/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import Foundation

// MARK: - ShowResult

//Dustin Rename when V1 removed.
public struct ShowResultsV2: Decodable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [ShowV2]?
}

// MARK: - Show
public struct ShowV2: Decodable {
    public let id: Int?
    public let uri: String?
    public let program: Int?
    public let programURI: String?
    public let hosts: [Int]?
    public let hostURIs: [String]?
    public let programName: String?
    public let programTags: String?
    public let hostNames: [String]?
    public let tagline: String?
    public let imageURI: String?
    public let startTime: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case uri
        case program
        case programURI = "program_uri"
        case hosts
        case hostURIs = "host_uris"
        case programName = "program_name"
        case programTags = "program_tags"
        case hostNames = "host_names"
        case tagline
        case imageURI = "image_uri"
        case startTime = "start_time"
    }
}
