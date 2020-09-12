//
//  ShowStartResultParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 9/12/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class ShowStartResultParseTests: XCTestCase {
    var showStart: Show?
    
    override func setUp() {
        super.setUp()
        
        guard
            let showStartData = retrieveJSONData(for: "ShowStartSample"),
            let showStart = parseResult(parseType: Show.self, data: showStartData)
            else {
                XCTFail("Failed"); return
        }
        
        self.showStart = showStart
    }
    
    func testShowParsing() {
        XCTAssertNotNil(showStart)

        XCTAssertNotNil(showStart?.id)
        XCTAssertNotNil(showStart?.uri)
        XCTAssertNotNil(showStart?.program)
        XCTAssertNotNil(showStart?.programURI)
        XCTAssertNotNil(showStart?.hosts?.first)
        XCTAssertNotNil(showStart?.programName)
        XCTAssertNotNil(showStart?.programTags)
        XCTAssertNotNil(showStart?.hostNames?.first)
        XCTAssertNotNil(showStart?.tagline)
        XCTAssertNotNil(showStart?.imageURI)
        XCTAssertNotNil(showStart?.startTime)
    }
}
