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
    let count: Int
    let next: String?
    let previous: String?
    let results: [ShowV2]
}

// MARK: - Show
public struct ShowV2: Decodable {
    let id: Int
    let uri: String
    let program: Int
    let programURI: String
    let hosts: [Int]
    let hostURIs: [String]
    let programName, programTags: String
    let hostNames: [String]
    let tagline: String
    let imageURI: String
    let startTime: Date

    enum CodingKeys: String, CodingKey {
        case id, uri, program
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
