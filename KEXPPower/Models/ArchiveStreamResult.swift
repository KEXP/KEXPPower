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
    private var sgURLNext: URL?
    
    // Not in use at the moment
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

//let uri = dict["sg-url"] as? String,
//let offset = dict["sg-offset"] as? Double,


//{
//    "sg-url-next": "https://kexp-archive.streamguys1.com/content/kexp/20190928120002-16-187-variety-mix-weekends.mp3",
//    "url": "http://50.234.71.235:8090/stream-32.mp3?date=2019-09-28T18:59:00Z",
//    "sg-url": "https://kexp-archive.streamguys1.com/content/kexp/20190928090003-15-244-positive-vibrations.mp3",
//    "uri2": "http://50.234.71.235:8090/stream-32.mp3?date=2019-09-28T18:59:00Z",
//    "sg-offset": 10737,
//    "uri": "https://streaming.kexp.net/stream-32.mp3?date=2019-09-28T18:59:00Z",
//    "ssl-url": "https://streaming.kexp.net/stream-32.mp3?date=2019-09-28T18:59:00Z"
//}
