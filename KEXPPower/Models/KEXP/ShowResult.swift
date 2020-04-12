//
//  ShowResults.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 3/3/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import Foundation

// MARK: - ShowResult
public struct ShowResult: Decodable {
    public let count: Int?
    public let next: String?
    public let previous: String?
    public let shows: [Show]?

    enum CodingKeys: String, CodingKey {
        case shows = "results"
        case next
        case previous
        case count
    }
}

// MARK: - Show
public struct Show: Decodable {
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

extension Show {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
        program = try values.decodeIfPresent(Int.self, forKey: .program)
        programURI = try values.decodeIfPresent(String.self, forKey: .programURI)
        hosts = try values.decodeIfPresent([Int].self, forKey: .hosts)
        hostURIs = try values.decodeIfPresent([String].self, forKey: .hostURIs)
        programName = try values.decodeIfPresent(String.self, forKey: .programName)
        programTags = try values.decodeIfPresent(String.self, forKey: .programTags)
        hostNames = try values.decodeIfPresent([String].self, forKey: .hostNames)
        tagline = try values.decodeIfPresent(String.self, forKey: .tagline)
        imageURI = try values.decodeIfPresent(String.self, forKey: .imageURI)

        let dateString = try values.decode(String.self, forKey: .startTime)

        if let parsedDate = DateFormatter.airdateFormatter.date(from: dateString) {
            startTime = parsedDate
        } else {
            startTime = nil
        }
    }
}
