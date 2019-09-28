//
//  PlayResultParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 6/30/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class PlayResultParseTests: XCTestCase {
    var firstPlay: Play?
    
    override func setUp() {
        super.setUp()
        
        guard
            let playResultData = retrieveJSONData(for: "PlaySample"),
            let playResult = parseResult(parseType: PlayResult.self, data: playResultData)
            else {
                XCTFail("Failed"); return
        }
        
        firstPlay = playResult.playlist?.first
    }
    
    func testPlayParsing() {
        XCTAssertNotNil(firstPlay)
        
        XCTAssert(firstPlay?.showId == 104048) 
        XCTAssert(firstPlay?.playType.name == "Media play")
        XCTAssert(firstPlay?.playType.playTypeId == 1)
        
        XCTAssertNotNil(firstPlay?.airDate)
        XCTAssert(firstPlay?.epochAirDate == 1561348828000)
        XCTAssert(firstPlay?.epochAirDateV2 == "/Date(1561348828000)/")
        
        let bit32URL = "http://50.234.71.239:8090/stream-32.mp3?date=2019-06-24T04:00:28Z"
        let bit64URL = "http://50.234.71.239:8090/stream-64.mp3?date=2019-06-24T04:00:28Z"
        let bit128URL = "http://50.234.71.239:8090/stream-128.mp3?date=2019-06-24T04:00:28Z"
        let bit256URL = "http://50.234.71.239:8090/stream-256.mp3?date=2019-06-24T04:00:28Z"

        XCTAssert(firstPlay?.archiveURLs?.archive32BitURL?.absoluteString == bit32URL)
        XCTAssert(firstPlay?.archiveURLs?.archive64BitURL?.absoluteString == bit64URL)
        XCTAssert(firstPlay?.archiveURLs?.archive128BitURL?.absoluteString == bit128URL)
        XCTAssert(firstPlay?.archiveURLs?.archive256BitURL?.absoluteString == bit256URL)
    
        XCTAssert(firstPlay?.artist?.artistId == 215762)
        XCTAssert(firstPlay?.artist?.name == "Mala, Joe Armon-Jones & Nubya Garcia")
        XCTAssert(firstPlay?.artist?.isLocal == false)

        XCTAssert(firstPlay?.release?.name == "Untitled (18 Artists)")
        XCTAssert(firstPlay?.release?.releaseId == 353490)
        
        let largeImageURL = "https://www.SomeLargeImageURI.edu"
        let smallImageURL = "https://www.SomeSmallImageURI.edu"
        
        XCTAssert(firstPlay?.release?.largeImageURL?.absoluteString == largeImageURL)
        XCTAssert(firstPlay?.release?.smallImageURL?.absoluteString == smallImageURL)
        
        XCTAssert(firstPlay?.releaseEvent?.releaseEventId == 713920)
        XCTAssert(firstPlay?.releaseEvent?.year == 2019)
        
        XCTAssert(firstPlay?.track?.trackId == 1383598)
        XCTAssert(firstPlay?.track?.name == "Scratch & Erase")
        
        XCTAssert(firstPlay?.label?.labelId == 59244)
        XCTAssert(firstPlay?.label?.name == "The Vinyl Factory")

        XCTAssert(firstPlay?.comments?.first?.commentId == 1238727)
        XCTAssertNotNil(firstPlay?.comments?.first?.text)
    }
}

