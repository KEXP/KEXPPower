//
//  AppleMusicResultParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 10/24/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class AppleMusicResultParseTests: XCTestCase {
    var searchTrack: SearchTrack?
    
    override func setUp() {
        super.setUp()
        
        guard
            let appleMusicResultData = retrieveJSONData(for: "AppleMusicSample"),
            let appleMusicResult = parseResult(parseType: AppleMusicResult.self, data: appleMusicResultData)
            else {
                XCTFail("Failed"); return
        }
        
        searchTrack = appleMusicResult.results?.first
    }

    func testParsingAppleMusicSearchTrack() {
        let trackURLString = "https://music.apple.com/us/album/this-year/1445589195?i=1445589202&uo=4"
        XCTAssertNotNil(searchTrack)
        XCTAssertEqual(searchTrack?.trackViewUrl?.absoluteString, trackURLString)
    }
}
