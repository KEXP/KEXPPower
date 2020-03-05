//
//  ShowResultV2ParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 3/3/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class ShowResultV2ParseTests: XCTestCase {
    var firstShow: ShowV2?
    
    override func setUp() {
        super.setUp()
        
        guard
            let showResultData = retrieveJSONData(for: "ShowV2Sample"),
            let showResult = parseResult(parseType: ShowResultsV2.self, data: showResultData)
            else {
                XCTFail("Failed"); return
        }
        
        firstShow = showResult.results?.first
    }
    
    func testShowParsing() {
        XCTAssertNotNil(firstShow)

        XCTAssertTrue(firstShow?.id == 46732)
        XCTAssertTrue(firstShow?.uri == "https://api.kexp.org/v2/shows/46732/")
        XCTAssertTrue(firstShow?.program == 20)
        XCTAssertTrue(firstShow?.programURI == "https://api.kexp.org/v2/programs/20/")
        XCTAssertTrue(firstShow?.hosts?.first == 44)
        XCTAssertTrue(firstShow?.programName == "Wo' Pop")
        XCTAssertTrue(firstShow?.programTags == "Electronic,World")
        XCTAssertTrue(firstShow?.hostNames?.first == "Gabriel Teodros")
        XCTAssertTrue(firstShow?.tagline == "666")
        XCTAssertTrue(firstShow?.imageURI == "https://www.kexp.org/filer/canonical/1529968564/10621/")
        XCTAssertNotNil(firstShow?.startTime)
    }
}
