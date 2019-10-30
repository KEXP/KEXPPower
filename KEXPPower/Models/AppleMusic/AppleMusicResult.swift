//
//  AppleMusicResult.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 10/24/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

// MARK: - AppleMusicResult

public struct AppleMusicResult: Decodable {
    public let resultCount: Int?
    public let results: [SearchTrack]?
    
//    enum CodingKeys: String, CodingKey {
//        case resultCount
//        case results
//    }
}

// MARK: - SearchTrack

public struct SearchTrack: Decodable {
    public let trackViewUrl: URL?
    
//    enum CodingKeys: String, CodingKey {
//        case trackViewUrl
//    }
}
