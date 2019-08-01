//
//  ShowResultParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 7/1/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class ShowResultParseTests: XCTestCase {
    var firstShow: Show?
    
    override func setUp() {
        super.setUp()
        
        guard
            let showResultData = retrieveJSONData(for: "ShowSample"),
            let showResult = parseResult(parseType: ShowResult.self, data: showResultData)
            else {
                XCTFail("Failed"); return
        }
        
        firstShow = showResult.showlist?.first
    }
    
    func testShowParsing() {
        XCTAssertNotNil(firstShow)
        
        XCTAssertTrue(firstShow?.showId == 104083)
        
        XCTAssertTrue(firstShow?.program?.programId == 57)
        XCTAssertTrue(firstShow?.program?.name == "Midnight in a Perfect World")
        XCTAssertNotNil(firstShow?.program?.description)
        XCTAssertTrue(firstShow?.program?.tags == "Eclectic,DJ,Variety Mix")
        
        XCTAssertTrue(firstShow?.program?.channel.channelId == 1)
        XCTAssertTrue(firstShow?.program?.channel.name == "KEXP 90.3 FM Seattle")
        
        let streamURI = "http://live-mp3-128.kexp.org/listen.pls"
        XCTAssertTrue(firstShow?.program?.channel.streamURL?.absoluteString == streamURI)
        XCTAssertTrue(firstShow?.program?.channel.timezone == "Pacific Standard Time")
        
        XCTAssertNotNil(firstShow?.airDate)
        XCTAssertTrue(firstShow?.epochAirDate == 1561834820000)
        XCTAssertTrue(firstShow?.epochAirDateV2 == "/Date(1561834820000)/")
        XCTAssertTrue(firstShow?.tagline == "tagline")
        
        XCTAssertTrue(firstShow?.hosts?.first?.hostId == 309)
        XCTAssertTrue(firstShow?.hosts?.first?.name == "Guest DJ")
        
        let imageURI = "https://www.SomeImageURI.edu"
        let newimageURI = "https://www.SomeNewImageURI.edu"
        XCTAssertTrue(firstShow?.hosts?.first?.imageURL?.absoluteString == imageURI)
        XCTAssertTrue(firstShow?.hosts?.first?.newImageURL == newimageURI)
        XCTAssertTrue(firstShow?.hosts?.first?.isActive == true)
        
        let bit32URL = "http://50.234.71.239:8090/stream-32.mp3?date=2019-06-29T19:00:20Z"
        let bit64URL = "http://50.234.71.239:8090/stream-64.mp3?date=2019-06-29T19:00:20Z"
        let bit128URL = "http://50.234.71.239:8090/stream-128.mp3?date=2019-06-29T19:00:20Z"
        let bit256URL = "http://50.234.71.239:8090/stream-256.mp3?date=2019-06-29T19:00:20Z"
        
        XCTAssert(firstShow?.archiveURLs?.archive32BitURL?.absoluteString == bit32URL)
        XCTAssert(firstShow?.archiveURLs?.archive64BitURL?.absoluteString == bit64URL)
        XCTAssert(firstShow?.archiveURLs?.archive128BitURL?.absoluteString == bit128URL)
        XCTAssert(firstShow?.archiveURLs?.archive256BitURL?.absoluteString == bit256URL)
    }
}
