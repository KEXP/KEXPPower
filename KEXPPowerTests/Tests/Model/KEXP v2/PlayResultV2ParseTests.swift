//
//  PlayResultV2ParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 3/4/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class PlayResultV2ParseTests: XCTestCase {
    var trackplay: PlayV2?
    var airbreak: PlayV2?
    
    override func setUp() {
        super.setUp()
        
        guard
            let playResultData = retrieveJSONData(for: "PlayV2Sample"),
            let playResult = parseResult(parseType: PlayResultV2.self, data: playResultData)
            else {
                XCTFail("Failed"); return
        }
        
        airbreak = playResult.results?.first
        trackplay = playResult.results?.last
    }
    
    func testTrackplayParsing() {
        XCTAssertNotNil(trackplay)
        
        XCTAssertTrue(trackplay?.id == 2707620)
        XCTAssertTrue(trackplay?.uri == "https://api.kexp.org/v2/plays/2707620/")
        XCTAssertNotNil(trackplay?.airdate)
        XCTAssertTrue(trackplay?.show == 46732)
        XCTAssertTrue(trackplay?.showURI == "https://api.kexp.org/v2/shows/46732/")
        XCTAssertTrue(trackplay?.imageURI == "http://someImageUri.com")
        XCTAssertTrue(trackplay?.thumbnailURI == "http://someThumbImageUri.com")
        XCTAssertTrue(trackplay?.song == "We'll Meet Again (Dub Style)")
        XCTAssertTrue(trackplay?.trackID == "666")
        XCTAssertTrue(trackplay?.recordingID == "666")
        XCTAssertTrue(trackplay?.artist == "Elias Negash")
        XCTAssertTrue(trackplay?.artistIDs?.first == "666")
        XCTAssertTrue(trackplay?.album == "We'll Meet Again (Dub Style)")
        XCTAssertTrue(trackplay?.releaseID == "release_id")
        XCTAssertTrue(trackplay?.releaseGroupID == "release_group_id")
        XCTAssertTrue(trackplay?.labels?.first == "SophEl Recordings")
        XCTAssertTrue(trackplay?.releaseDate == "2019-12-16")
        XCTAssertTrue(trackplay?.rotationStatus == "rotation_status")
        XCTAssertTrue(trackplay?.isLocal == false)
        XCTAssertTrue(trackplay?.isRequest == false)
        XCTAssertTrue(trackplay?.isLive == false)
        XCTAssertTrue(trackplay?.comment?.isEmpty == false)
        XCTAssertTrue(trackplay?.playType == .trackplay)
    }
    
    func testAirbreakParsing() {
        XCTAssertNotNil(airbreak)
        
        XCTAssertTrue(airbreak?.id == 2707639)
        XCTAssertTrue(airbreak?.uri == "https://api.kexp.org/v2/plays/2707639/")
        XCTAssertNotNil(airbreak?.airdate)
        XCTAssertTrue(airbreak?.show == 46732)
        XCTAssertTrue(airbreak?.showURI == "https://api.kexp.org/v2/shows/46732/")
        XCTAssertTrue(airbreak?.playType == .airbreak)
    }
}
