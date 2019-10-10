//
//  ArchiveStreamResult.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 10/9/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

public struct ArchiveStreamResult: Decodable {
    public var streamURL: URL?
    public var offset: Double?

    // Not in use at the moment
    private var sgURLNext: URL?
    private var url: URL?
    private var uri2: URL?
    private var uri: URL?
    
    enum CodingKeys: String, CodingKey {
        case streamURL = "sg-url"
        case offset = "sg-offset"
        case sgURLNext = "sg-url-next"
        case url
        case uri2
        case uri
    }
}
