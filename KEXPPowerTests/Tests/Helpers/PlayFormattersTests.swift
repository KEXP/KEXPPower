//
//  PlayFormatterTests.swift
//  KEXPPowerTests
//
//  Created by Jeff Sorrentino on 3/9/23.
//  Copyright © 2023 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class PlayFormattersTests: XCTestCase {
    var playResult: PlayResult?
    
    override func setUp() {
        super.setUp()
        
        guard
            let playResultData = retrieveJSONData(for: "PlaySample"),
            let playResult = parseResult(parseType: PlayResult.self, data: playResultData)
        else {
            XCTFail("Failed"); return
        }
        self.playResult = playResult
    }
    func testFormattedReleaseYear() {
        let lastTrackPlay = playResult?.plays?.last
        XCTAssertEqual(lastTrackPlay?.formattedReleaseYear, "2019 - SophEl Recordings")
    }
    
    func testFormattedReleaseYearWithNoYear() {
        let firstTrackPlay = playResult?.plays?[1]
        XCTAssertNil(firstTrackPlay?.formattedReleaseYear)
    }
    
    func testFormattedReleaseYearWithNoLabel() {
        let secondTrackPlay = playResult?.plays?[2]
        XCTAssertEqual(secondTrackPlay?.formattedReleaseYear, "2020")
    }
}
